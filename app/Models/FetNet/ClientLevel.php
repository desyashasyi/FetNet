<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;

/**
 * A client tier/plan level (lookup table). Table `fetnet_client_level`.
 */
class ClientLevel extends Model
{
    protected $table   = 'fetnet_client_level';
    protected $guarded = [];
}
