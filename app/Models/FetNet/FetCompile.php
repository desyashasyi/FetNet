<?php

namespace App\Models\FetNet;

use App\Models\User;
use Illuminate\Database\Eloquent\Model;

/**
 * One FET solver run for a client + semester: tracks the generated input file, solver
 * process lifecycle, result size/duration, and publish state. Table
 * `fetnet_fet_compile`. Columns include size_bytes, duration_ms, solver_pid,
 * solver_started_at/finished_at, published_at, published_by.
 */
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

    /** User who published this run's timetable. */
    public function publishedBy()
    {
        return $this->belongsTo(\App\Models\User::class, 'published_by');
    }

    /** Owning client. */
    public function client()
    {
        return $this->belongsTo(Client::class, 'client_id');
    }

    /** Semester this run targets. */
    public function semester()
    {
        return $this->belongsTo(Semester::class, 'semester_id');
    }

    /** User who started this run. */
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
