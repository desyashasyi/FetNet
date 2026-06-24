<?php

namespace Tests\Feature\FetNet;

use Livewire\Livewire;
use Tests\TestCase;

class TeacherNotAvailablePaginationTest extends TestCase
{
    private const COMPONENT = 'pages::shared.time-teacher-not-available-summary';

    /** @return array<int, array<string, mixed>> */
    private function rows(int $n): array
    {
        $rows = [];
        // Insert out of alphabetical order to prove the component sorts.
        foreach (array_reverse(range(1, $n)) as $i) {
            $rows[] = [
                'id'           => $i,
                'teacher'      => '[T' . $i . '] Teacher ' . str_pad((string) $i, 2, '0', STR_PAD_LEFT),
                'slots'        => 0,
                'blockedMap'   => [],
                'weight'       => 100.0,
                'program_name' => null,
            ];
        }

        return $rows;
    }

    public function test_teachers_paginate_ten_per_page_sorted_alphabetically(): void
    {
        $c = Livewire::test(self::COMPONENT, ['rows' => $this->rows(23), 'numberOfDays' => 5]);

        // First page holds 10, alphabetically first; paginator reports the totals.
        $p1 = $c->viewData('teachers');
        $this->assertSame(23, $p1->total());
        $this->assertSame(3, $p1->lastPage());
        $this->assertSame(1, $p1->currentPage());
        $this->assertCount(10, $p1->items());
        $this->assertSame('[T1] Teacher 01', $p1->items()[0]['teacher']);

        // Second page continues in order (Livewire pagination via gotoPage).
        $c->call('gotoPage', 2);
        $this->assertSame('[T11] Teacher 11', $c->viewData('teachers')->items()[0]['teacher']);

        // Last page holds the remainder.
        $c->call('gotoPage', 3);
        $this->assertCount(3, $c->viewData('teachers')->items());
    }

    public function test_no_pager_needed_for_ten_or_fewer(): void
    {
        $p = Livewire::test(self::COMPONENT, ['rows' => $this->rows(10), 'numberOfDays' => 5])
            ->viewData('teachers');

        $this->assertSame(1, $p->lastPage());
        $this->assertFalse($p->hasPages());
    }

    public function test_search_filters_by_teacher_name(): void
    {
        $p = Livewire::test(self::COMPONENT, [
            'rows'         => $this->rows(23),
            'numberOfDays' => 5,
            'search'       => 'Teacher 17',
        ])->viewData('teachers');

        $this->assertSame(1, $p->total());
        $this->assertSame(1, $p->lastPage());
        $this->assertSame('[T17] Teacher 17', $p->items()[0]['teacher']);
    }
}
