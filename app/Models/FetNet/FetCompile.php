<?php

namespace App\Models\FetNet;

use App\Models\User;
use Illuminate\Database\Eloquent\Model;

class FetCompile extends Model
{
    protected $table   = 'fetnet_fet_compile';
    protected $guarded = [];

    protected $casts = [
        'size_bytes'         => 'integer',
        'duration_ms'        => 'integer',
        'solver_pid'         => 'integer',
        'solver_started_at'  => 'datetime',
        'solver_finished_at' => 'datetime',
        'published_at'       => 'datetime',
    ];

    public function publishedBy()
    {
        return $this->belongsTo(\App\Models\User::class, 'published_by');
    }

    public function client()
    {
        return $this->belongsTo(Client::class, 'client_id');
    }

    public function semester()
    {
        return $this->belongsTo(Semester::class, 'semester_id');
    }

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
