<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * A node in a program's self-referential student hierarchy: batch (parent_id null) →
 * group → sub-group, all carrying program_id. Table `fetnet_student` (soft-deletes).
 * Activities are scheduled against group/sub-group nodes. Deleting cascades soft-delete
 * to descendants and detaches activities.
 */
class Student extends Model
{
    use SoftDeletes;

    protected $table   = 'fetnet_student';
    protected $guarded = [];

    /** Owning study program. */
    public function program()
    {
        return $this->belongsTo(Program::class, 'program_id');
    }

    /** Parent node (null for a top-level batch). */
    public function parent()
    {
        return $this->belongsTo(Student::class, 'parent_id');
    }

    /** Child nodes (groups under a batch, sub-groups under a group), name-ordered. */
    public function children()
    {
        return $this->hasMany(Student::class, 'parent_id')->orderBy('name');
    }

    /** Activities this group/sub-group attends (pivot fetnet_activity_student). */
    public function activities()
    {
        return $this->belongsToMany(Activity::class, 'fetnet_activity_student', 'student_id', 'activity_id');
    }

    /** Cascade soft-delete to descendants and detach from activities. */
    protected static function booted(): void
    {
        static::deleting(function (Student $student) {
            // Cascade soft-delete children (groups/subgroups)
            $student->children()->get()->each->delete();
            // Detach from activities
            $student->activities()->detach();
        });
    }
}
