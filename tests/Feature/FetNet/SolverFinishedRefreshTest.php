<?php

namespace Tests\Feature\FetNet;

use Livewire\Livewire;
use Tests\TestCase;

class SolverFinishedRefreshTest extends TestCase
{
    private const CARD = 'pages::client.timetable.solver-log-card';

    public function test_card_notifies_parent_on_successful_finish(): void
    {
        Livewire::test(self::CARD)
            ->call('onFinished', ['status' => 'success', 'result_path' => 'x.fet'])
            ->assertDispatched('solver-finished');
    }

    public function test_card_does_not_notify_parent_on_failure(): void
    {
        Livewire::test(self::CARD)
            ->call('onFinished', ['status' => 'failed', 'message' => 'boom'])
            ->assertNotDispatched('solver-finished');
    }
}
