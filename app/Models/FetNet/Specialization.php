<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * A subject specialization/track within a program (e.g. a concentration). Table
 * `fetnet_specialization` (soft-deletes). Columns: program_id, code, name. On delete,
 * detaches itself from subjects by nulling their specialization_id (matches the DB
 * nullOnDelete constraint).
 */
class Specialization extends Model
{
    use SoftDeletes;

    protected $table   = 'fetnet_specialization';
    protected $guarded = [];

    /** Owning study program. */
    public function program()
    {
        return $this->belongsTo(Program::class, 'program_id');
    }

    /** Subjects tagged with this specialization. */
    public function subjects()
    {
        return $this->hasMany(Subject::class, 'specialization_id');
    }

    /** On soft-delete, null out subjects' specialization_id. */
    protected static function booted(): void
    {
        static::deleting(function (Specialization $specialization) {
            // Nullify subject specialization_id on soft-delete (match nullOnDelete DB constraint)
            $specialization->subjects()->update(['specialization_id' => null]);
        });
    }
}
