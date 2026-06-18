<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * A per-program category for subjects (e.g. compulsory, elective). Table
 * `fetnet_subject_type` (soft-deletes). On delete, nulls subjects' type_id.
 */
class SubjectType extends Model
{
    use SoftDeletes;

    protected $table   = 'fetnet_subject_type';
    protected $guarded = [];

    /** Owning study program. */
    public function program()
    {
        return $this->belongsTo(Program::class, 'program_id');
    }

    /** Subjects of this type. */
    public function subjects()
    {
        return $this->hasMany(Subject::class, 'type_id');
    }

    /** On soft-delete, null out subjects' type_id. */
    protected static function booted(): void
    {
        static::deleting(function (SubjectType $type) {
            $type->subjects()->update(['type_id' => null]);
        });
    }
}
