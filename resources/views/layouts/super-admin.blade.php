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
    #sa-nav::-webkit-scrollbar { display: none; }
    #sa-nav { scrollbar-width: none; -ms-overflow-style: none; }
</style>
<nav id="sa-nav"
     class="fixed bottom-0 left-0 right-0 z-50 bg-purple-900 shadow-[0_-2px_10px_rgba(0,0,0,0.3)] h-16 overflow-x-auto flex justify-center">
<div class="flex h-full items-center min-w-max px-2 gap-0.5">

    @php
        $item   = 'flex flex-col items-center justify-center gap-0.5 px-3 py-1 rounded-xl h-12 transition-all';
        $active = 'bg-purple-600 text-white';
        $dim    = 'text-purple-400 hover:text-purple-200';
    @endphp

    <a href="{{ route('super-admin.idx') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('super-admin.idx') ? $active : $dim }}">
        <x-icon name="o-squares-2x2" class="w-5 h-5" />
        <span class="text-[9px] font-semibold leading-none">Dashboard</span>
    </a>

    <a href="{{ route('super-admin.university') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('super-admin.university') ? $active : $dim }}">
        <x-icon name="o-academic-cap" class="w-5 h-5" />
        <span class="text-[9px] font-medium leading-none">Universities</span>
    </a>

    <a href="{{ route('super-admin.faculty') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('super-admin.faculty') ? $active : $dim }}">
        <x-icon name="o-building-library" class="w-5 h-5" />
        <span class="text-[9px] font-medium leading-none">Faculties</span>
    </a>

    <a href="{{ route('super-admin.client') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('super-admin.client') ? $active : $dim }}">
        <x-icon name="o-building-office-2" class="w-5 h-5" />
        <span class="text-[9px] font-medium leading-none">Clients</span>
    </a>

    <a href="{{ route('super-admin.user') }}" wire:navigate
       class="{{ $item }} {{ request()->routeIs('super-admin.user') ? $active : $dim }}">
        <x-icon name="o-users" class="w-5 h-5" />
        <span class="text-[9px] font-medium leading-none">Users</span>
    </a>

</div>
</nav>

<x-toast />
</body>
</html>
