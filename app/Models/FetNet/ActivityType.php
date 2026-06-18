<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;

/**
 * A global kind of activity (lecture, lab, seminar, …). Table `fetnet_activity_type`.
 */
class ActivityType extends Model
{
    protected $table   = 'fetnet_activity_type';
    protected $guarded = [];

    /** Activities of this type. */
    public function activities()
    {
        return $this->hasMany(Activity::class, 'type_id');
    }
}
