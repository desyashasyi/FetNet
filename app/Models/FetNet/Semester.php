<?php

namespace App\Models\FetNet;

use Illuminate\Database\Eloquent\Model;

/**
 * One academic term under a client + academic year. Table `fetnet_semester`.
 * Columns: client_id, academic_year_id, semester (1=odd|2=even), name, start_month,
 * end_month, lecture_start, lecture_end. `label` accessor renders a human term name.
 */
class Semester extends Model
{
    protected $table   = 'fetnet_semester';
    protected $guarded = [];
    protected $casts   = [
        'lecture_start' => 'date',
        'lecture_end'   => 'date',
    ];

    /** Owning client. */
    public function client()
    {
        return $this->belongsTo(Client::class, 'client_id', 'id');
    }

    /** Parent academic year. */
    public function academicYear()
    {
        return $this->belongsTo(AcademicYear::class, 'academic_year_id');
    }

    /**
     * Human label: the term name (or Odd/Even fallback) plus a "(Month–Month)" range
     * when start/end months are set, e.g. "Odd (September–December)".
     */
    public function getLabelAttribute(): string
    {
        $names = [
            1  => 'January',   2  => 'February', 3  => 'March',
            4  => 'April',     5  => 'May',       6  => 'June',
            7  => 'July',      8  => 'August',    9  => 'September',
            10 => 'October',   11 => 'November',  12 => 'December',
        ];

        $name  = $this->name ?? ($this->semester == 1 ? 'Odd' : 'Even');
        $start = $names[$this->start_month] ?? '';
        $end   = $names[$this->end_month]   ?? '';

        return $name . ($start && $end ? " ({$start}–{$end})" : '');
    }
}
