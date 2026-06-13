<?php

use Livewire\Component;

new class extends Component
{
    /** @var array<int, array{id:int, abbrev:string, name:string}> */
    public array $programs = [];

    /** @var array<int, array{teacher_id:int, name:string, code:?string, perProgram:array<int,int>, total:int}> */
    public array $rows = [];

    public function with(): array
    {
        $headers = array_merge(
            [['key' => 'lecturer', 'label' => 'Lecturer']],
            array_map(fn ($p) => [
                'key'   => 'p_' . $p['id'],
                'label' => $p['abbrev'],
                'class' => 'text-center',
            ], $this->programs),
            [['key' => 'total', 'label' => 'Total', 'class' => 'text-center font-bold']],
        );

        $tableRows = array_map(function ($r) {
            $row = ['lecturer' => $r['name'] . ($r['code'] ? " ({$r['code']})" : '')];
            foreach ($this->programs as $p) {
                $row['p_' . $p['id']] = $r['perProgram'][$p['id']] ?? '';
            }
            $row['total'] = $r['total'];
            return $row;
        }, $this->rows);

        return ['headers' => $headers, 'tableRows' => $tableRows];
    }
}; ?>

<x-card>
    <x-table :headers="$headers" :rows="$tableRows" container-class="overflow-x-auto">
        @foreach($programs as $p)
            @scope('header_p_' . $p['id'], $header)
                <span title="{{ $p['name'] }}">{{ $p['abbrev'] }}</span>
            @endscope
        @endforeach
    </x-table>
</x-card>
