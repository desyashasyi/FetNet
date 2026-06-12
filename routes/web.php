<?php

use App\Http\Controllers\Auth\CasController;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Route;

// ─── Root ────────────────────────────────────────────────────────────────────
Route::get('/', function () {
    if (!auth()->check()) return redirect()->route('login');
    $user = auth()->user();
    if ($user->hasRole('super-admin')) return redirect()->route('super-admin.idx');
    if ($user->hasRole('client'))      return redirect()->route('client.idx');
    if ($user->hasRole('operator'))    return redirect()->route('operator.idx');
    return redirect()->route('program.idx');
});

// ─── Auth ────────────────────────────────────────────────────────────────────
Route::middleware('guest')->group(function () {
    Route::livewire('/login', 'pages::auth.⚡login')->name('login');
});

Route::get('/logout', function () {
    Auth::logout();
    request()->session()->invalidate();
    request()->session()->regenerateToken();
    return redirect()->route('login');
})->middleware('auth')->name('logout');

// ─── SSO CAS UPI ─────────────────────────────────────────────────────────────
Route::prefix('auth/cas')->name('auth.cas.')->group(function () {
    Route::get('/redirect', [CasController::class, 'redirect'])->name('redirect');
    Route::get('/callback', [CasController::class, 'callback'])->name('callback');
    Route::get('/logout',   [CasController::class, 'logout'])->name('logout')->middleware('auth');
});

// ─── Impersonation ───────────────────────────────────────────────────────────
Route::get('/impersonate/leave', function () {
    $originalId = session()->pull('impersonator_id');
    if ($originalId) {
        $original = App\Models\User::find($originalId);
        if ($original) {
            Auth::login($original);
            return redirect()->route('super-admin.client');
        }
    }
    return redirect()->route('login');
})->middleware('auth')->name('impersonate.leave');

// ─── Super Admin ──────────────────────────────────────────────────────────────
Route::middleware(['auth', 'role:super-admin'])->prefix('super-admin')->name('super-admin.')->group(function () {
    Route::livewire('/',           'pages::super-admin.⚡idx')->name('idx');
    Route::livewire('/university', 'pages::super-admin.university.⚡idx')->name('university');
    Route::livewire('/faculty',    'pages::super-admin.faculty.⚡idx')->name('faculty');
    Route::livewire('/client',     'pages::super-admin.client.⚡idx')->name('client');
    Route::livewire('/user',       'pages::super-admin.user.⚡idx')->name('user');
});

// ─── Admin ────────────────────────────────────────────────────────────────────
Route::middleware(['auth', 'role:super-admin|client'])->group(function () {
    Route::livewire('/client',                      'pages::client.⚡idx')->name('client.idx');
    Route::livewire('/client/program',              'pages::client.program.⚡idx')->name('client.program');
    Route::livewire('/client/data/basic',           'pages::client.data.basic.⚡idx')->name('client.data.basic');
    Route::livewire('/client/data/academic-year',   'pages::client.data.academic-year.⚡idx')->name('client.data.academic-year');
    Route::livewire('/client/data/teachers',        'pages::client.data.teachers.⚡idx')->name('client.data.teachers');
    Route::livewire('/client/data/space',           'pages::client.data.space.⚡idx')->name('client.data.space');
    Route::livewire('/client/data/activities',      'pages::client.data.activities.⚡idx')->name('client.data.activities');
    // Time constraints
    Route::livewire('/client/time/teachers',        'pages::client.time.teachers.⚡idx')->name('client.time.teachers');
    Route::livewire('/client/time/students',        'pages::client.time.students.⚡idx')->name('client.time.students');
    // Timetable compile + generate
    Route::livewire('/client/timetable',            'pages::client.timetable.⚡idx')->name('client.timetable');
    Route::livewire('/client/timetable/view',       'pages::client.timetable.view.⚡idx')->name('client.timetable.view');
    Route::get('/client/timetable/{compile}/download',
        \App\Http\Controllers\FetNet\FetCompileDownloadController::class)
        ->name('client.timetable.download');
    Route::get('/client/timetable/{compile}/result',
        \App\Http\Controllers\FetNet\SolverResultDownloadController::class)
        ->name('client.timetable.result');
});

// ─── Program ──────────────────────────────────────────────────────────────────
Route::middleware(['auth'])->prefix('program')->name('program.')->group(function () {
    Route::livewire('/',                    'pages::program.⚡idx')->name('idx');
    Route::livewire('/data/specialization', 'pages::program.data.specialization.⚡idx')->name('data.specialization');
    Route::livewire('/data/subjects',       'pages::program.data.subjects.⚡idx')->name('data.subjects');
    Route::livewire('/data/teachers',       'pages::program.data.teachers.⚡idx')->name('data.teachers');
    Route::livewire('/data/students',       'pages::program.data.students.⚡idx')->name('data.students');
    Route::livewire('/data/activities',     'pages::program.data.activities.⚡idx')->name('data.activities');
    // Time constraints
    Route::livewire('/time/teachers',       'pages::program.time.teachers.⚡idx')->name('time.teachers');
    Route::livewire('/time/students',       'pages::program.time.students.⚡idx')->name('time.students');
    Route::livewire('/time/activities',     'pages::program.time.activities.⚡idx')->name('time.activities');
    // Space constraints
    Route::livewire('/space/teachers',      'pages::program.space.teachers.⚡idx')->name('space.teachers');
    Route::livewire('/space/students',      'pages::program.space.students.⚡idx')->name('space.students');
    Route::livewire('/space/activities',    'pages::program.space.activities.⚡idx')->name('space.activities');
    // Timetable
    Route::livewire('/timetable/teachers',  'pages::program.timetable.teachers.⚡idx')->name('timetable.teachers');
    Route::livewire('/timetable/students',  'pages::program.timetable.students.⚡idx')->name('timetable.students');
    Route::livewire('/timetable/rooms',     'pages::program.timetable.rooms.⚡idx')->name('timetable.rooms');
});

// ─── Operator ─────────────────────────────────────────────────────────────────
// Per-program user, hanya akses timetable yang sudah di-publish.
Route::middleware(['auth', 'role:operator'])->prefix('operator')->name('operator.')->group(function () {
    Route::livewire('/',          'pages::operator.⚡idx')->name('idx');
    Route::livewire('/timetable', 'pages::operator.timetable.⚡idx')->name('timetable');
});
