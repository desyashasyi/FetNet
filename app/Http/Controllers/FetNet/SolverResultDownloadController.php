<?php

namespace App\Http\Controllers\FetNet;

use App\Http\Controllers\Controller;
use App\Models\FetNet\Client;
use App\Models\FetNet\FetCompile;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\HttpFoundation\StreamedResponse;

class SolverResultDownloadController extends Controller
{
    public function __invoke(FetCompile $compile): StreamedResponse
    {
        $user = auth()->user();
        abort_unless($user, 403);

        if (! $user->hasRole('super-admin')) {
            $client = Client::where('user_id', $user->id)->first();
            abort_unless($client && $client->id === $compile->client_id, 403);
        }

        abort_unless($compile->solver_result_path, 404);
        abort_unless(Storage::disk('local')->exists($compile->solver_result_path), 404);

        $filename = basename($compile->solver_result_path);
        return Storage::disk('local')->download($compile->solver_result_path, $filename);
    }
}
