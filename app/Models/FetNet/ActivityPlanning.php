<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * Links a subject to a program + semester to mark it "planned" for that term; its
 * activities hang off it. Table `fetnet_activity_planning` (soft-deletes); one row per
 * (subject_id, program_id, semester_id). Soft-deleting cascades to its activities, and
 * restoring cascades-restore them (see booted()).
 */
class ActivityPlanning extends Model
{
    use SoftDeletes;

    protected $table   = 'fetnet_activity_planning';
    protected $guarded = [];

    /** The planned subject. */
    public function subject()
    {
        return $this->belongsTo(Subject::class, 'subject_id');
    }

    /** Owning study program. */
    public function program()
    {
        return $this->belongsTo(Program::class, 'program_id');
    }

    /** The term this plan applies to. */
    public function semester()
    {
        return $this->belongsTo(Semester::class, 'semester_id');
    }

    /** Activities realising this plan. */
    public function activities()
    {
        return $this->hasMany(Activity::class, 'planning_id');
    }

    /** Cascade soft-delete to activities; cascade-restore them on restore. */
    protected static function booted(): void
    {
        static::deleting(function (ActivityPlanning $planning) {
            // Soft-delete all activities when planning is soft-deleted
            $planning->activities()->get()->each->delete();
        });

        static::restoring(function (ActivityPlanning $planning) {
            // Restore all activities when planning is restored
            Activity::withTrashed()
                ->where('planning_id', $planning->id)
                ->get()
                ->each->restore();
        });
    }
}
