<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;

/**
 * A per-program label that can be attached to activities. Table `fetnet_activity_tag`.
 * Columns: program_id, name.
 */
class ActivityTag extends Model
{
    protected $table   = 'fetnet_activity_tag';
    protected $guarded = [];

    /** Owning study program. */
    public function program()
    {
        return $this->belongsTo(Program::class, 'program_id');
    }
}
