<?php

namespace App\Imports\FetNet;

use App\Models\FetNet\Building;
use App\Models\FetNet\Space;
use App\Models\FetNet\SpaceType;
use App\Support\CodeGenerator;
use Illuminate\Support\Collection;
use Illuminate\Support\Str;
use Maatwebsite\Excel\Concerns\ToCollection;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

/**
 * Excel/CSV importer for rooms (spaces) scoped to a client. Heading-row based; matches
 * building + type by code OR name (case-insensitive), auto-registering an unknown
 * building or space type on the fly. Non-destructive: each row is updateOrCreate keyed
 * on (name, client_id) and un-trashed. Tracks $imported / $skipped counts for the job.
 */
class SpaceImport implements ToCollection, WithHeadingRow
{
    public int   $imported = 0;
    public int   $skipped  = 0;

    public function __construct(
        public int $clientId,
    ) {}

    /**
     * Upsert each spreadsheet row into a Space. Rows without a name are skipped;
     * building/type keys auto-create their lookups when missing.
     */
    public function collection(Collection $rows): void
    {
        // Build mutable lookup maps — index by both code and name for flexible matching
        $buildingMap = [];
        Building::where('client_id', $this->clientId)->get(['id', 'name', 'code'])
            ->each(function ($b) use (&$buildingMap) {
                if ($b->code) $buildingMap[strtolower(trim($b->code))] = $b->id;
                if ($b->name) $buildingMap[strtolower(trim($b->name))] = $b->id;
            });

        // Index type by both code and name for flexible matching
        $typeMap = [];
        SpaceType::all(['id', 'code', 'name'])
            ->each(function ($t) use (&$typeMap) {
                if ($t->code) $typeMap[strtolower(trim($t->code))] = $t->id;
                if ($t->name) $typeMap[strtolower(trim($t->name))] = $t->id;
            });

        foreach ($rows as $row) {
            $name = trim($row['name'] ?? '');
            if ($name === '') {
                $this->skipped++;
                continue;
            }

            // Support both _code columns and plain name columns as fallback
            $buildingKey  = strtolower(trim($row['building_code'] ?? $row['building'] ?? ''));
            $typeKey      = strtolower(trim($row['type_code'] ?? $row['type'] ?? ''));
            $capacity     = isset($row['capacity']) && is_numeric($row['capacity'])
                ? (int) $row['capacity']
                : null;

            // Auto-register building if key given but not found
            if ($buildingKey !== '' && ! isset($buildingMap[$buildingKey])) {
                $rawName  = trim($row['building_code'] ?? $row['building'] ?? $buildingKey);
                $building = Building::firstOrCreate(
                    ['client_id' => $this->clientId, 'name' => $rawName],
                    ['code' => CodeGenerator::fromPhrase($rawName, 5)],
                );
                $buildingMap[$buildingKey]                      = $building->id;
                $buildingMap[strtolower(trim($building->name))] = $building->id;
                if ($building->code) {
                    $buildingMap[strtolower(trim($building->code))] = $building->id;
                }
            }

            // Auto-register space type if key given but not found
            if ($typeKey !== '' && ! isset($typeMap[$typeKey])) {
                $rawName = trim($row['type_code'] ?? $row['type'] ?? $typeKey);
                $type    = SpaceType::firstOrCreate(
                    ['code' => CodeGenerator::fromPhrase($rawName)],
                    ['name' => Str::title($rawName)],
                );
                $typeMap[$typeKey]                       = $type->id;
                $typeMap[strtolower(trim($type->name))]  = $type->id;
                $typeMap[strtolower(trim($type->code))]  = $type->id;
            }

            Space::withTrashed()->updateOrCreate(
                ['name' => $name, 'client_id' => $this->clientId],
                [
                    'code'        => trim($row['code'] ?? '') ?: null,
                    'type_id'     => $typeKey ? ($typeMap[$typeKey] ?? null) : null,
                    'building_id' => $buildingKey ? ($buildingMap[$buildingKey] ?? null) : null,
                    'floor'       => trim($row['floor'] ?? '') ?: null,
                    'capacity'    => $capacity,
                    'deleted_at'  => null,
                ]
            );

            $this->imported++;
        }
    }
}
