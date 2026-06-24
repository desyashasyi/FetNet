<?php

namespace Tests\Feature;

// use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ExampleTest extends TestCase
{
    /**
     * The app has no public landing page: "/" always redirects. An unauthenticated
     * visitor is sent to the login route (authenticated users are routed by role).
     */
    public function test_the_root_redirects_a_guest_to_login(): void
    {
        $response = $this->get('/');

        $response->assertRedirect(route('login'));
    }
}
