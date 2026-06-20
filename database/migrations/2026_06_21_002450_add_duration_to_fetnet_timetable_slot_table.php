<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Store how many consecutive hours a placed activity occupies, so the timetable can
 * render a class spanning its full SKS duration instead of a single starting slot.
 */
return new class extends Migration
{
    public function up(): void
    {
        // Idempotent: the server may have already added this column via an earlier,
        // since-removed migration. Only add it if missing; the backfill still runs.
        if (! Schema::hasColumn('fetnet_timetable_slot', 'duration')) {
            Schema::table('fetnet_timetable_slot', function (Blueprint $table) {
                $table->unsignedSmallInteger('duration')->default(1)->after('hour_index');
            });
        }

        // Backfill existing slots from their activity's duration so spans are correct
        // without forcing a re-generate. Split activities (with sub-activities) keep the
        // default of 1 since their parts can't be recovered from a single collapsed slot.
        // Portable PHP loop (works on both MariaDB and the SQLite test DB).
        $durations = DB::table('fetnet_activity')->pluck('duration', 'id');
        $split     = DB::table('fetnet_sub_activity')->distinct()->pluck('activity_id')->flip();

        foreach (DB::table('fetnet_timetable_slot')->select('id', 'activity_id')->get() as $s) {
            if (isset($split[$s->activity_id])) continue;
            $d = max(1, (int) ($durations[$s->activity_id] ?? 1));
            DB::table('fetnet_timetable_slot')->where('id', $s->id)->update(['duration' => $d]);
        }
    }

    public function down(): void
    {
        if (Schema::hasColumn('fetnet_timetable_slot', 'duration')) {
            Schema::table('fetnet_timetable_slot', function (Blueprint $table) {
                $table->dropColumn('duration');
            });
        }
    }
};
