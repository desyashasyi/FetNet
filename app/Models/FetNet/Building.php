<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;

/**
 * A physical building belonging to a client; groups rooms (spaces). Table
 * `fetnet_building`. Columns: client_id, name, …
 */
class Building extends Model
{
    protected $table   = 'fetnet_building';
    protected $guarded = [];

    /** Owning client. */
    public function client()
    {
        return $this->belongsTo(Client::class, 'client_id');
    }

    /** Rooms in this building. */
    public function spaces()
    {
        return $this->hasMany(Space::class, 'building_id');
    }
}
