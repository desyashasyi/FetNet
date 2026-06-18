<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;

/**
 * A curriculum (catalog) year for a program; subjects belong to one curriculum year.
 * Table `fetnet_curriculum_year`. Columns: program_id, year.
 */
class CurriculumYear extends Model
{
    protected $table   = 'fetnet_curriculum_year';
    protected $guarded = [];

    /** Owning study program. */
    public function program()
    {
        return $this->belongsTo(Program::class, 'program_id');
    }

    /** Subjects in this curriculum year. */
    public function subjects()
    {
        return $this->hasMany(Subject::class, 'curriculum_year_id');
    }
}
