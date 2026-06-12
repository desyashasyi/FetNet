<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;

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

    public function client()   { return $this->belongsTo(Client::class, 'client_id'); }
    public function semester() { return $this->belongsTo(Semester::class, 'semester_id'); }
    public function activity() { return $this->belongsTo(Activity::class, 'activity_id'); }
    public function room()     { return $this->belongsTo(Space::class, 'room_id'); }
}
