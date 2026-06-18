<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use App\Models\FetNet\ActivityTag;
use App\Models\FetNet\ActivityPlanning;

/**
 * A scheduled teaching activity: one timetable-bound occurrence of a planned subject.
 * Table `fetnet_activity` (soft-deletes). Columns: program_id, planning_id, type_id,
 * duration (hours), active. Team-taught and multi-group via pivots; deleting detaches
 * all pivots (see booted()).
 */
class Activity extends Model
{
    use SoftDeletes;

    protected $table   = 'fetnet_activity';
    protected $guarded = [];
    protected $casts   = ['active' => 'boolean'];

    /** Owning study program. */
    public function program()
    {
        return $this->belongsTo(Program::class, 'program_id');
    }

    /** The subject+semester plan this activity realises. */
    public function planning()
    {
        return $this->belongsTo(ActivityPlanning::class, 'planning_id');
    }

    /** Activity type (lecture, lab, …). */
    public function type()
    {
        return $this->belongsTo(ActivityType::class, 'type_id');
    }

    /** Ordered sub-activities (split sessions) of this activity. */
    public function subActivities()
    {
        return $this->hasMany(SubActivity::class, 'activity_id')->orderBy('order');
    }

    /** Assigned lecturers (pivot fetnet_activity_teacher); full credit each. */
    public function teachers()
    {
        return $this->belongsToMany(Teacher::class, 'fetnet_activity_teacher', 'activity_id', 'teacher_id');
    }

    /** Attending student groups/sub-groups (pivot fetnet_activity_student). */
    public function students()
    {
        return $this->belongsToMany(Student::class, 'fetnet_activity_student', 'activity_id', 'student_id');
    }

    /** Free-form tags (pivot fetnet_activity_tag_map). */
    public function tags()
    {
        return $this->belongsToMany(ActivityTag::class, 'fetnet_activity_tag_map', 'activity_id', 'tag_id');
    }

    /** Eligible/assigned rooms (pivot fetnet_activity_space, carries assigned_by). */
    public function spaces()
    {
        return $this->belongsToMany(Space::class, 'fetnet_activity_space', 'activity_id', 'space_id')
                    ->withPivot('assigned_by');
    }

    /** On delete, detach every pivot so no orphan pivot rows remain. */
    protected static function booted(): void
    {
        static::deleting(function (Activity $activity) {
            $activity->teachers()->detach();
            $activity->students()->detach();
            $activity->tags()->detach();
            $activity->spaces()->detach();
        });
    }
}
