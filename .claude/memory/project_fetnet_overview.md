---
name: FetNet Project Overview
description: Full stack, domain, architecture, and purpose of FetNet academic timetable system
type: project
originSessionId: fef1c5ae-2da2-49e7-a745-eebf32ca0992
---
Academic timetable management & scheduling system for universities (UPI - Universitas Pendidikan Indonesia).

**Why:** Multi-institution scheduling with CAS SSO, conflict-free timetable generation, resource management.

**How to apply:** Context for all FetNet tasks — understand domain before suggesting changes.

## Stack
- Laravel 12.x, PHP 8.2+, Livewire 4.2
- Mary UI 2.6 (all UI components — x-* components only)
- Spatie Permission 6.24 (roles: super-admin, client, program)
- Tailwind CSS 4.1.18 + DaisyUI 5.5.14
- MariaDB 11 + Redis (Docker)
- Laravel Horizon + Reverb (queue + websocket)
- Maatwebsite Excel 3.1 (import/export)
- Spatie PDF 1.8

## Domain
- Universities → Faculties → Clients (institutions) → Programs
- Academic years (2024/2025) → Semesters
- Subjects → ActivityPlannings → Activities
- Teachers, Students (hierarchical), Spaces/Buildings
- Constraints (time/space) → Timetable generation

## Roles
- `super-admin` — full access via Gate::before()
- `client` — manages programs for their institution (SSO NIP: length > 7)
- `program` — per-program access (SSO NIM: length ≤ 7)

## Key Paths
- Models: `app/Models/FetNet/` (31 models)
- Controllers: `app/Http/Controllers/Auth/CasController.php` (CAS SSO only)
- Livewire pages: `resources/views/pages/` (auth, super-admin, client, program)
- Layout: `resources/views/layouts/app.blade.php` (single layout, Mary UI sidebar)
- Jobs: `app/Jobs/FetNet/` (import + space assignment)
- Routes: `routes/web.php`

## Docker Services
- app (PHP, port 8001/5175), nginx (8088), mariadb (3310), redis, worker-timetable
- Network: WebFPTE
- Timetable worker queue: `redis:timetable`, timeout 600s

## CAS SSO
- Server: sso.upi.edu, version 3.0
- Handled in `CasController.php`
