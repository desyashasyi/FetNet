#!/usr/bin/env sh
set -e

# ─── System permissions ──────────────────────────────────────────────────────
echo "[entrypoint] fixing /var/run/php and /var/log permissions…"
mkdir -p /var/run/php /var/log
chown -R www-data:www-data /var/run/php /var/log
chmod -R 777 /var/run/php /var/log

echo "[entrypoint] fixing app storage permissions…"
chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
chmod -R 777 /var/www/storage /var/www/bootstrap/cache

if [ -n "$WWWUSER" ] && [ -n "$WWWGROUP" ]; then
    echo "[entrypoint] updating www-data UID/GID to ${WWWUSER}:${WWWGROUP}…"
    usermod -u "$WWWUSER"  www-data 2>/dev/null || true
    groupmod -g "$WWWGROUP" www-data 2>/dev/null || true
fi

cd /var/www

run_as_www() { gosu www-data "$@"; }

# ─── Bootstrap (only on primary app container) ───────────────────────────────
# Worker containers reuse the same image but must NOT run migrations.
# The app service sets BOOTSTRAP_APP=1 in docker-compose.yml; workers leave it unset.
if [ "$BOOTSTRAP_APP" = "1" ]; then
    echo "[bootstrap] BOOTSTRAP_APP=1 — running first-time setup…"

    if [ ! -f .env ] && [ -f .env.example ]; then
        echo "[bootstrap] .env missing → copying .env.example"
        cp .env.example .env
        chown www-data:www-data .env
    fi

    if [ ! -f vendor/autoload.php ]; then
        echo "[bootstrap] vendor/ missing → composer install"
        run_as_www composer install --no-interaction --no-progress --prefer-dist
    fi

    if [ -f .env ] && ! grep -q '^APP_KEY=base64:' .env; then
        echo "[bootstrap] APP_KEY missing → generating"
        run_as_www php artisan key:generate --force
    fi

    # Wait for DB connection. depends_on healthcheck usually covers this; we retry the
    # actual `migrate --force` since it's the operation we care about.
    echo "[bootstrap] running migrations (retry on connection failure)…"
    attempts=0
    until run_as_www php artisan migrate --force 2>/tmp/mig.err; do
        attempts=$((attempts + 1))
        if [ "$attempts" -ge 15 ]; then
            echo "[bootstrap] migrate failed after $attempts attempts. Last error:" >&2
            cat /tmp/mig.err >&2
            exit 1
        fi
        echo "[bootstrap] migrate attempt $attempts failed, retrying in 3s…"
        sleep 3
    done

    echo "[bootstrap] running seeders (idempotent)…"
    run_as_www php artisan db:seed --force

    if [ ! -e public/storage ]; then
        echo "[bootstrap] linking storage…"
        run_as_www php artisan storage:link || true
    fi

    if [ ! -d public/build ]; then
        echo "[bootstrap] frontend assets not built — building now…"
        if [ ! -d node_modules ]; then
            run_as_www npm install --no-audit --no-fund
        fi
        run_as_www npm run build
    fi

    echo "[bootstrap] done."
fi

echo "[entrypoint] switching to www-data and exec \"$*\""
exec gosu www-data "$@"
