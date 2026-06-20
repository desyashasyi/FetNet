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

        $c->assertSet('page', 1)
            ->assertViewHas('total', 23)
            ->assertViewHas('lastPage', 3);

        // First page holds 10, alphabetically first.
        $page1 = $c->viewData('pageRows');
        $this->assertCount(10, $page1);
        $this->assertSame('[T1] Teacher 01', $page1[0]['teacher']);

        // Second page continues in order.
        $c->call('nextPage', 3)->assertSet('page', 2);
        $this->assertSame('[T11] Teacher 11', $c->viewData('pageRows')[0]['teacher']);

        // Last page holds the remainder.
        $c->call('nextPage', 3)->assertSet('page', 3);
        $this->assertCount(3, $c->viewData('pageRows'));
    }

    public function test_no_pager_needed_for_ten_or_fewer(): void
    {
        Livewire::test(self::COMPONENT, ['rows' => $this->rows(10), 'numberOfDays' => 5])
            ->assertViewHas('lastPage', 1);
    }

    public function test_search_filters_by_teacher_name(): void
    {
        $c = Livewire::test(self::COMPONENT, [
            'rows'         => $this->rows(23),
            'numberOfDays' => 5,
            'search'       => 'Teacher 17',
        ]);

        $c->assertViewHas('total', 1)->assertViewHas('lastPage', 1);
        $this->assertSame('[T17] Teacher 17', $c->viewData('pageRows')[0]['teacher']);
    }
}
