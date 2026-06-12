---
name: FetNet Routes Map
description: All route groups, middleware, and Livewire page mappings
type: project
originSessionId: fef1c5ae-2da2-49e7-a745-eebf32ca0992
---
All routes in `routes/web.php`. All use Livewire components. **Why:** Quick lookup when adding/modifying routes.

## Route Groups

### Auth
- `GET /login` → `pages::auth.⚡login`
- `POST /logout` → logout
- `GET /auth/cas/*` → CasController (redirect, callback, logout)
- `GET /impersonate/leave` → impersonate.leave

### Super Admin (`middleware: auth, role:super-admin`)
- `/super-admin/` → dashboard
- `/super-admin/university`
- `/super-admin/faculty`
- `/super-admin/client`
- `/super-admin/user`

### Client (`middleware: auth, role:super-admin|client`)
- `/client` → dashboard
- `/client/program`
- `/client/data/basic`
- `/client/data/academic-year`
- `/client/data/teachers`
- `/client/data/space`
- `/client/data/activities`
- `/client/time/teachers`
- `/client/time/students`

### Program (`middleware: auth, prefix: /program`)
- `/program/` → dashboard
- `/program/data/specialization`
- `/program/data/subjects`
- `/program/data/teachers`
- `/program/data/students`
- `/program/data/activities`
- `/program/data/tags`
- `/program/time/teachers`
- `/program/time/students`
- `/program/time/activities`
- `/program/space/teachers`
- `/program/space/students`
- `/program/space/activities`
- `/program/timetable/teachers`
- `/program/timetable/students`
