<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;

/**
 * A program's claim/reservation on a room (priority access for scheduling). Table
 * `fetnet_space_claim`; links a space to a program.
 */
class SpaceClaim extends Model
{
    protected $table   = 'fetnet_space_claim';
    protected $guarded = [];

    /** The claimed room. */
    public function space()
    {
        return $this->belongsTo(Space::class, 'space_id');
    }

    /** The program holding the claim. */
    public function program()
    {
        return $this->belongsTo(Program::class, 'program_id');
    }
}
