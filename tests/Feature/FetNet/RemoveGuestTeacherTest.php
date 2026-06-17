<?php

namespace Tests\Feature\FetNet;

use App\Models\FetNet\Client;
use App\Models\FetNet\Program;
use App\Models\FetNet\Teacher;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Livewire\Livewire;
use Tests\TestCase;

class RemoveGuestTeacherTest extends TestCase
{
    use RefreshDatabase;

    private const PAGE = 'pages::program.data.teachers.⚡idx';

    public function test_remove_guest_detaches_the_guest_teacher(): void
    {
        $user    = User::factory()->create();
        $client  = Client::create(['user_id' => $user->id]);
        $program = Program::create(['client_id' => $client->id, 'user_id' => $user->id, 'abbrev' => 'TE', 'name' => 'TE Program']);

        // A teacher from another program, added as a guest to this program.
        $otherProgram = Program::create(['client_id' => $client->id, 'user_id' => User::factory()->create()->id, 'abbrev' => 'EE', 'name' => 'EE Program']);
        $guest        = Teacher::create(['program_id' => $otherProgram->id, 'name' => 'Guesty', 'code' => 'GST']);
        $program->guestTeachers()->attach($guest->id);

        $this->assertSame(1, $program->guestTeachers()->count());

        Livewire::actingAs($user)->test(self::PAGE)
            ->assertSee('Guesty')                          // shown in the main table
            ->assertSeeHtml('guest')                       // flagged with a guest sign
            ->call('confirmRemoveGuest', $guest->id)       // opens confirmation
            ->assertSet('guestRemoveModal', true)
            ->assertSet('guestRemoveId', $guest->id)
            ->call('removeGuestTeacher')                   // confirm (uses stored id)
            ->assertSet('guestRemoveModal', false)
            ->assertDontSee('Guesty');                     // gone after remove

        $this->assertSame(0, $program->guestTeachers()->count());
    }
}
