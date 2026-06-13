<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, viewport-fit=cover">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>{{ isset($title) ? $title.' - '.config('app.name') : config('app.name') }}</title>
    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>
<body class="min-h-screen font-sans antialiased bg-base-200 pb-16 overflow-x-hidden">

{{-- Top bar --}}
<div class="navbar bg-purple-700 text-white sticky top-0 z-30 px-4">
    <div class="flex-1">
        <x-app-brand class="text-white [&_*]:text-white" />
    </div>
    @if($user = auth()->user())
        <span class="text-sm text-white/70 mr-2">{{ $user->name }}</span>
        <x-button icon="o-power" class="btn-circle btn-ghost btn-sm text-white hover:bg-purple-800"
                  tooltip="Sign Out" no-wire-navigate link="{{ route('logout') }}" />
    @endif
</div>

{{-- Content --}}
<div class="container mx-auto px-4 py-5 max-w-7xl">
    {{ $slot }}
</div>

{{-- Bottom nav --}}
<style>
    #prog-nav::-webkit-scrollbar { display: none; }
    #prog-nav { scrollbar-width: none; -ms-overflow-style: none; }
</style>
<nav id="prog-nav"
     class="fixed bottom-0 left-0 right-0 z-50 bg-purple-900 shadow-[0_-2px_10px_rgba(0,0,0,0.3)] h-16 overflow-x-auto flex justify-center">
<div class="flex h-full items-center min-w-max px-2 gap-0.5">

    @php
        $item    = 'flex flex-col items-center justify-center gap-0.5 px-3 py-1 rounded-xl h-12 transition-all';
        $active  = 'bg-purple-600 text-white';
        $dim     = 'text-purple-400 hover:text-purple-200';
        $sep     = 'flex flex-col items-center justify-center px-1 select-none';
        $divider = 'w-px h-7 bg-purple-700/60 self-center mx-0.5';
    @endphp

    {{-- Home --}}
    <a href="{{ route('program.idx') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('program.idx') ? $active : $dim }}">
        <x-icon name="o-home" class="w-5 h-5" />
        <span class="text-[9px] font-semibold leading-none">Home</span>
    </a>

    <div class="{{ $divider }}"></div>

    {{-- Data --}}
    <div class="{{ $sep }}">
        <x-icon name="o-circle-stack" class="w-3 h-3 text-purple-600" />
        <span class="text-[8px] font-bold text-purple-600 uppercase tracking-wide leading-none">Data</span>
    </div>
    <a href="{{ route('program.data.subjects') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('program.data.subjects') ? $active : $dim }}">
        <x-icon name="o-book-open" class="w-5 h-5" />
        <span class="text-[9px] font-medium leading-none">Subjects</span>
    </a>
    <a href="{{ route('program.data.teachers') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('program.data.teachers') ? $active : $dim }}">
        <x-icon name="o-academic-cap" class="w-5 h-5" />
        <span class="text-[9px] font-medium leading-none">Teachers</span>
    </a>
    <a href="{{ route('program.data.students') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('program.data.students') ? $active : $dim }}">
        <x-icon name="o-user-group" class="w-5 h-5" />
        <span class="text-[9px] font-medium leading-none">Students</span>
    </a>
    <a href="{{ route('program.data.activities') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('program.data.activities') ? $active : $dim }}">
        <x-icon name="o-table-cells" class="w-5 h-5" />
        <span class="text-[9px] font-medium leading-none">Activities</span>
    </a>
    <a href="{{ route('program.data.workload') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('program.data.workload') ? $active : $dim }}">
        <x-icon name="o-scale" class="w-5 h-5" />
        <span class="text-[9px] font-medium leading-none">Workload</span>
    </a>

    <div class="{{ $divider }}"></div>

    {{-- Time --}}
    <div class="{{ $sep }}">
        <x-icon name="o-clock" class="w-3 h-3 text-purple-600" />
        <span class="text-[8px] font-bold text-purple-600 uppercase tracking-wide leading-none">Time</span>
    </div>
    <a href="{{ route('program.time.teachers') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('program.time.teachers') ? $active : $dim }}">
        <x-icon name="o-user" class="w-5 h-5" />
        <span class="text-[9px] font-medium leading-none">Teachers</span>
    </a>
    <a href="{{ route('program.time.students') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('program.time.students') ? $active : $dim }}">
        <x-icon name="o-user-group" class="w-5 h-5" />
        <span class="text-[9px] font-medium leading-none">Students</span>
    </a>
    <a href="{{ route('program.time.activities') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('program.time.activities') ? $active : $dim }}">
        <x-icon name="o-calendar-days" class="w-5 h-5" />
        <span class="text-[9px] font-medium leading-none">Activities</span>
    </a>

    <div class="{{ $divider }}"></div>

    {{-- Space --}}
    <div class="{{ $sep }}">
        <x-icon name="o-building-office" class="w-3 h-3 text-purple-600" />
        <span class="text-[8px] font-bold text-purple-600 uppercase tracking-wide leading-none">Space</span>
    </div>
    <a href="{{ route('program.space.teachers') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('program.space.teachers') ? $active : $dim }}">
        <x-icon name="o-user" class="w-5 h-5" />
        <span class="text-[9px] font-medium leading-none">Teachers</span>
    </a>
    <a href="{{ route('program.space.students') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('program.space.students') ? $active : $dim }}">
        <x-icon name="o-user-group" class="w-5 h-5" />
        <span class="text-[9px] font-medium leading-none">Students</span>
    </a>
    <a href="{{ route('program.space.activities') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('program.space.activities') ? $active : $dim }}">
        <x-icon name="o-calendar-days" class="w-5 h-5" />
        <span class="text-[9px] font-medium leading-none">Activities</span>
    </a>

    <div class="{{ $divider }}"></div>

    {{-- Timetable --}}
    <div class="{{ $sep }}">
        <x-icon name="o-squares-2x2" class="w-3 h-3 text-purple-600" />
        <span class="text-[8px] font-bold text-purple-600 uppercase tracking-wide leading-none">Timetable</span>
    </div>
    <a href="{{ route('program.timetable.teachers') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('program.timetable.teachers') ? $active : $dim }}">
        <x-icon name="o-user" class="w-5 h-5" />
        <span class="text-[9px] font-medium leading-none">Teachers</span>
    </a>
    <a href="{{ route('program.timetable.students') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('program.timetable.students') ? $active : $dim }}">
        <x-icon name="o-user-group" class="w-5 h-5" />
        <span class="text-[9px] font-medium leading-none">Students</span>
    </a>
    <a href="{{ route('program.timetable.rooms') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('program.timetable.rooms') ? $active : $dim }}">
        <x-icon name="o-building-office" class="w-5 h-5" />
        <span class="text-[9px] font-medium leading-none">Rooms</span>
    </a>

</div>
</nav>

<x-toast />
</body>
</html>
