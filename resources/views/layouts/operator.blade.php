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
<div class="navbar bg-emerald-700 text-white sticky top-0 z-30 px-4">
    <div class="flex-1">
        <x-app-brand class="text-white [&_*]:text-white" />
    </div>
    @if($user = auth()->user())
        <span class="text-sm text-white/70 mr-2">{{ $user->name }}</span>
        <x-button icon="o-power" class="btn-circle btn-ghost btn-sm text-white hover:bg-emerald-800"
                  tooltip="Sign Out" no-wire-navigate link="{{ route('logout') }}" />
    @endif
</div>

{{-- Content --}}
<div class="container mx-auto px-4 py-5 max-w-7xl">
    {{ $slot }}
</div>

{{-- Bottom nav --}}
<nav class="fixed bottom-0 left-0 right-0 z-50 bg-emerald-900 shadow-[0_-2px_10px_rgba(0,0,0,0.3)] h-16 flex justify-center">
<div class="flex h-full items-center px-2 gap-1">

    @php
        $item   = 'flex flex-col items-center justify-center gap-0.5 px-4 py-1 rounded-xl h-12 transition-all';
        $active = 'bg-emerald-600 text-white';
        $dim    = 'text-emerald-400 hover:text-emerald-200';
    @endphp

    <a href="{{ route('operator.idx') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('operator.idx') ? $active : $dim }}">
        <x-icon name="o-home" class="w-5 h-5" />
        <span class="text-[10px] font-semibold leading-none">Home</span>
    </a>

    <a href="{{ route('operator.timetable') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('operator.timetable') ? $active : $dim }}">
        <x-icon name="o-calendar-days" class="w-5 h-5" />
        <span class="text-[10px] font-semibold leading-none">Timetable</span>
    </a>

</div>
</nav>

<x-toast />

</body>
</html>
