<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;

/**
 * A time constraint applied to one activity, fed to the FET solver (e.g. preferred or
 * forbidden slots). Table `fetnet_time_constraint_activity`.
 */
class ActivityTimeConstraint extends Model
{
    protected $table   = 'fetnet_time_constraint_activity';
    protected $guarded = [];

    /** The constrained activity. */
    public function activity()
    {
        return $this->belongsTo(Activity::class, 'activity_id');
    }
}
