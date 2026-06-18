<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;

/**
 * Membership of a program in a cluster: programs in the same cluster_base share
 * teachers and scheduling scope. Table `fetnet_cluster`; one row per
 * (program_id, cluster_base_id).
 */
class Cluster extends Model
{
    protected $table   = 'fetnet_cluster';
    protected $guarded = [];

    /** The member program. */
    public function program()
    {
        return $this->belongsTo(Program::class, 'program_id', 'id');
    }

    /** The cluster this membership belongs to. */
    public function base()
    {
        return $this->belongsTo(ClusterBase::class, 'cluster_base_id', 'id');
    }
}
