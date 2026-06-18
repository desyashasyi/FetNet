<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;

/**
 * A faculty within a university (shared institution lookup). Table
 * `institution_faculty`. Columns: university_id, name, …
 */
class Faculty extends Model
{
    protected $table   = 'institution_faculty';
    protected $guarded = [];

    /** Parent university. */
    public function university()
    {
        return $this->belongsTo(University::class, 'university_id', 'id');
    }
}
