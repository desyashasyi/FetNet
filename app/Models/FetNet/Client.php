<?php

namespace App\Models\FetNet;

use App\Models\User;
use Illuminate\Database\Eloquent\Model;

/**
 * The top-level tenant of FetNet — an institution/unit that owns programs, semesters,
 * buildings, and timetables. Table `fetnet_client`. Columns: user_id (owner),
 * client_level_id, university_id, faculty_id, …
 */
class Client extends Model
{
    protected $table   = 'fetnet_client';
    protected $guarded = [];

    /** Owning user account. */
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'id');
    }

    /** Client tier/level. */
    public function level()
    {
        return $this->belongsTo(ClientLevel::class, 'client_level_id', 'id');
    }

    /** Parent university. */
    public function university()
    {
        return $this->belongsTo(University::class, 'university_id', 'id');
    }

    /** Parent faculty. */
    public function faculty()
    {
        return $this->belongsTo(Faculty::class, 'faculty_id', 'id');
    }

    /** This client's cluster base (groups its programs for shared scheduling). */
    public function cluster()
    {
        return $this->hasOne(ClusterBase::class, 'client_id', 'id');
    }

    /** This client's configuration row. */
    public function config()
    {
        return $this->hasOne(ClientConfig::class, 'client_id', 'id');
    }
}
