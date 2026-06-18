<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use App\Models\FetNet\ActivityPlanning;

/**
 * A course/subject offered by a program. Table `fetnet_subject` (soft-deletes).
 * Columns: program_id, curriculum_year_id, specialization_id (nullable), type_id
 * (nullable), code, name, credit (SKS), semester. Unique per (code, program_id).
 * Deleting cascades soft-delete to its activity plannings (which cascade to activities).
 */
class Subject extends Model
{
    use SoftDeletes;

    protected $table   = 'fetnet_subject';
    protected $guarded = [];

    /** Owning study program. */
    public function program()
    {
        return $this->belongsTo(Program::class, 'program_id');
    }

    /** Curriculum (catalog) year. */
    public function curriculumYear()
    {
        return $this->belongsTo(CurriculumYear::class, 'curriculum_year_id');
    }

    /** Specialization/track, if any. */
    public function specialization()
    {
        return $this->belongsTo(Specialization::class, 'specialization_id');
    }

    /** Subject type (compulsory/elective/…), if any. */
    public function type()
    {
        return $this->belongsTo(SubjectType::class, 'type_id');
    }

    /** Per-semester plans for this subject. */
    public function activityPlannings()
    {
        return $this->hasMany(ActivityPlanning::class, 'subject_id');
    }

    /** Activities scheduled for this subject (through its plannings). */
    public function activities()
    {
        return $this->hasManyThrough(Activity::class, ActivityPlanning::class, 'subject_id', 'planning_id');
    }

    /** On soft-delete, cascade to plannings (which cascade to activities). */
    protected static function booted(): void
    {
        static::deleting(function (Subject $subject) {
            $subject->activityPlannings()->get()->each->delete();
        });
    }
}
