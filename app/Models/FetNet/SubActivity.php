<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;

/**
 * One ordered split-session of an activity (e.g. a 3-hour activity broken into parts).
 * Table `fetnet_sub_activity`. Columns: activity_id, order, …
 */
class SubActivity extends Model
{
    protected $table   = 'fetnet_sub_activity';
    protected $guarded = [];

    /** Parent activity. */
    public function activity()
    {
        return $this->belongsTo(Activity::class, 'activity_id');
    }
}
