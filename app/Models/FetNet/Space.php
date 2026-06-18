<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * A room/space available for scheduling. Table `fetnet_space` (soft-deletes). Columns:
 * client_id, type_id, building_id, faculty_id, program_id (owning prodi, nullable for
 * shared rooms), capacity, …
 */
class Space extends Model
{
    use SoftDeletes;

    protected $table   = 'fetnet_space';
    protected $guarded = [];

    /** Owning client. */
    public function client()
    {
        return $this->belongsTo(Client::class, 'client_id');
    }

    /** Room type (theory/lab/…). */
    public function type()
    {
        return $this->belongsTo(SpaceType::class, 'type_id');
    }

    /** Building this room sits in. */
    public function building()
    {
        return $this->belongsTo(Building::class, 'building_id');
    }

    /** Owning faculty. */
    public function faculty()
    {
        return $this->belongsTo(Faculty::class, 'faculty_id');
    }

    /** Owning study program (nullable for shared rooms). */
    public function program()
    {
        return $this->belongsTo(Program::class, 'program_id');
    }

    /** Reservations/claims placed on this room by programs. */
    public function claims()
    {
        return $this->hasMany(SpaceClaim::class, 'space_id');
    }

    /** Activities assigned to this room (pivot fetnet_activity_space). */
    public function activities()
    {
        return $this->belongsToMany(Activity::class, 'fetnet_activity_space', 'space_id', 'activity_id');
    }
}
