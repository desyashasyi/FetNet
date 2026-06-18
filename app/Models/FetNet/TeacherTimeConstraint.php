<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;

/**
 * A time-availability constraint for a lecturer (preferred/forbidden slots), fed to
 * the FET solver. Table `fetnet_time_constraint_teacher`.
 */
class TeacherTimeConstraint extends Model
{
    protected $table   = 'fetnet_time_constraint_teacher';
    protected $guarded = [];

    /** The constrained lecturer. */
    public function teacher()
    {
        return $this->belongsTo(Teacher::class, 'teacher_id');
    }
}
