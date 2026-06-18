<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;

/**
 * A time-availability constraint for a student group (preferred/forbidden slots), fed
 * to the FET solver. Table `fetnet_time_constraint_student`.
 */
class StudentTimeConstraint extends Model
{
    protected $table   = 'fetnet_time_constraint_student';
    protected $guarded = [];

    /** The constrained student group. */
    public function student()
    {
        return $this->belongsTo(Student::class, 'student_id');
    }
}
