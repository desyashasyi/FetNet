<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;

/**
 * A non-time scheduling constraint for a lecturer (fed to the FET solver). Table
 * `fetnet_teacher_constraint`.
 */
class TeacherConstraint extends Model
{
    protected $table   = 'fetnet_teacher_constraint';
    protected $guarded = [];

    /** The constrained lecturer. */
    public function teacher()
    {
        return $this->belongsTo(Teacher::class, 'teacher_id');
    }
}
