<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;

/**
 * One placed cell of a generated timetable: an activity in a room at a day/hour. Table
 * `fetnet_timetable_slot`. Columns: client_id, semester_id, activity_id, room_id,
 * day_index, hour_index, locked, weight_percent.
 */
class TimetableSlot extends Model
{
    protected $table   = 'fetnet_timetable_slot';
    protected $guarded = [];

    protected $casts = [
        'day_index'      => 'integer',
        'hour_index'     => 'integer',
        'locked'         => 'boolean',
        'weight_percent' => 'integer',
    ];

    /** Owning client. */
    public function client()   { return $this->belongsTo(Client::class, 'client_id'); }
    /** Semester this slot belongs to. */
    public function semester() { return $this->belongsTo(Semester::class, 'semester_id'); }
    /** The placed activity. */
    public function activity() { return $this->belongsTo(Activity::class, 'activity_id'); }
    /** The room the activity is placed in. */
    public function room()     { return $this->belongsTo(Space::class, 'room_id'); }
}
