---
name: FetNet Models & Relationships
description: All 31 FetNet domain models and their relationships
type: project
originSessionId: fef1c5ae-2da2-49e7-a745-eebf32ca0992
---
All models in `app/Models/FetNet/`. **Why:** Large domain — quick lookup before writing queries or migrations.

## Hierarchy
```
University → Faculty → Client → Program → Specialization
                                         → Subject (+ CurriculumYear, SubjectType)
                                         → Teacher (+ TeacherTimeConstraint)
                                         → Student (hierarchical, + StudentTimeConstraint)
                                         → ActivityPlanning → Activity → SubActivity
                                         → Space → SpaceClaim
                                         → Cluster → ClusterBase
```

## Models List
- **Org:** University, Faculty, Client, ClientLevel, ClientConfig
- **Program:** Program, Specialization, SubjectType, Subject, CurriculumYear
- **Calendar:** AcademicYear, Semester
- **People:** Teacher, Student
- **Constraints:** TeacherTimeConstraint, StudentTimeConstraint, TeacherConstraint, StudentConstraint, ActivityTimeConstraint
- **Activities:** ActivityPlanning, Activity, SubActivity, ActivityType, ActivityTag
- **Space:** Space, SpaceType, Building, SpaceClaim
- **Cluster:** Cluster, ClusterBase

## Key M2M
- Activity ↔ Teacher (pivot: fetnet_activity_teacher)
- Activity ↔ Student (pivot: fetnet_activity_student)
- Activity ↔ Space (pivot: assigned_by field)
- Activity ↔ ActivityTag

## Notable
- Student is hierarchical (parent/children for groups/subgroups)
- Activity has soft deletes cascading through planning
- ClientConfig stores schedule config: start_time, slot_duration, number_of_days, break times
