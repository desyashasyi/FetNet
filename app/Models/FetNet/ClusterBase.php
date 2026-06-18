<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;

/**
 * A cluster of programs under one client (the grouping that Cluster rows point to).
 * Table `fetnet_cluster_base`. Columns: client_id, name, …
 */
class ClusterBase extends Model
{
    protected $table   = 'fetnet_cluster_base';
    protected $guarded = [];

    /** Owning client. */
    public function client()
    {
        return $this->belongsTo(Client::class, 'client_id', 'id');
    }
}
