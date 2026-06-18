<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;

/**
 * A university (shared institution lookup, parent of faculties). Table
 * `institution_university`.
 */
class University extends Model
{
    protected $table   = 'institution_university';
    protected $guarded = [];
}
