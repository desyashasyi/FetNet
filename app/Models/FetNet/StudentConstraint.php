<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;

/**
 * A non-time scheduling constraint for a student group (fed to the FET solver). Table
 * `fetnet_student_constraint`.
 */
class StudentConstraint extends Model
{
    protected $table   = 'fetnet_student_constraint';
    protected $guarded = [];

    /** The constrained student group. */
    public function student()
    {
        return $this->belongsTo(Student::class, 'student_id');
    }
}
