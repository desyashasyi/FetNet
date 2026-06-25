<?php

namespace App\Services\FetNet;

use App\Models\FetNet\ClientConfig;
use App\Models\FetNet\Space;
use Illuminate\Support\Facades\Storage;

/**
 * Parse FET solver output (*_data_and_timetable.fet) and extract
 * Permanently_Locked activity slots into a normalised array, ready to
 * upsert into fetnet_timetable_slot.
 *
 * The Activity_Id in the output XML is the emitted FET id (sequential counter
 * from FetXmlBuilder). The compile job persists an emit-id -> db-activity-id
 * map alongside the input file; this parser uses that map to recover db ids.
 */
class FetSolutionParser
{
    /**
     * @return array<int, array{
     *   activity_id:int,
     *   day_index:?int,
     *   hour_index:?int,
     *   duration:int,
     *   room_id:?int,
     * }>
     */
    public function parse(string $resultRelPath, string $mapRelPath, int $clientId): array
    {
        $disk = Storage::disk('local');
        if (! $disk->exists($resultRelPath)) return [];

        $solutionPath = $this->solutionPathFromResult($resultRelPath);
        if (! $solutionPath || ! $disk->exists($solutionPath)) return [];

        $xml = @simplexml_load_string($disk->get($solutionPath));
        if (! $xml) return [];

        $reverse = [];
        if ($disk->exists($mapRelPath)) {
            $map = json_decode($disk->get($mapRelPath), true) ?: [];
            foreach ($map as $dbId => $emitIds) {
                foreach ((array) $emitIds as $emit) {
                    $reverse[(int) $emit] = (int) $dbId;
                }
            }
        }

        // Build name->1-based-index lookups from the source FET file in the same directory.
        $fetSource = $disk->exists($resultRelPath) ? @simplexml_load_string($disk->get($resultRelPath)) : null;
        $dayIndex  = $fetSource ? $this->buildPositionIndex($fetSource->Days_List?->Day ?? null, 'Name') : [];

        // Hour index must be the app's BOOKABLE-only index (matching TimetableSlot.hour_index
        // and the UI hour labels), NOT the FET Hours_List position — the FET list now also
        // contains the break hour, which would shift positions after lunch. Derive it from the
        // client config; fall back to FET positions only when no config is available.
        $hourIndex = $this->buildBookableHourIndex($clientId);
        if (empty($hourIndex) && $fetSource) {
            $hourIndex = $this->buildPositionIndex($fetSource->Hours_List?->Hour ?? null, 'Name');
        }

        // emitId -> duration (hours) from the source Activities_List. The solution
        // (*_activities.xml) only carries the start Day/Hour, so the span comes from here.
        $durByEmit = [];
        if ($fetSource && $fetSource->Activities_List) {
            foreach ($fetSource->Activities_List->Activity as $def) {
                $durByEmit[(int) $def->Id] = max(1, (int) $def->Duration);
            }
        }

        $rooms = Space::where('client_id', $clientId)->get(['id', 'code', 'name']);
        $roomByLabel = [];
        foreach ($rooms as $r) {
            if ($r->code) $roomByLabel[$r->code] = $r->id;
            if ($r->name) $roomByLabel[$r->name] = $r->id;
        }

        // *_activities.xml is the authoritative solution: one <Activity> per
        // placed item with Id, Day, Hour, Room. Empty <Room></Room> means FET
        // placed in time but could not assign a room (partial placement).
        $rows = [];
        foreach ($xml->Activity as $a) {
            $emitId = (int) $a->Id;
            $dbId   = $reverse[$emitId] ?? null;
            if (! $dbId) continue;

            $dayName  = trim((string) $a->Day);
            $hourName = trim((string) $a->Hour);
            $roomName = trim((string) $a->Room);

            $rows[] = [
                'activity_id' => $dbId,
                'day_index'   => $dayIndex[$dayName]   ?? null,
                'hour_index'  => $hourIndex[$hourName] ?? null,
                'duration'    => $durByEmit[$emitId]   ?? 1,
                'room_id'     => $roomName !== '' ? ($roomByLabel[$roomName] ?? null) : null,
            ];
        }
        return $rows;
    }

    /**
     * Map "fet-solve/{id}/timetables/{base}/{base}_data_and_timetable.fet"
     *  -> "fet-solve/{id}/timetables/{base}/{base}_activities.xml"
     */
    private function solutionPathFromResult(string $resultRelPath): ?string
    {
        $dir  = dirname($resultRelPath);
        $base = pathinfo($resultRelPath, PATHINFO_FILENAME);
        $base = preg_replace('/_data_and_timetable$/', '', $base);
        if (! $base) return null;
        return "{$dir}/{$base}_activities.xml";
    }

    /**
     * Build a "hour start name -> 1-based BOOKABLE index" map from the client config, skipping
     * break slots — this matches how FetXmlBuilder indexes bookable hours and how the app
     * stores TimetableSlot.hour_index, independent of the break's position in the FET file.
     *
     * @return array<string, int>
     */
    private function buildBookableHourIndex(int $clientId): array
    {
        $config = ClientConfig::where('client_id', $clientId)->first();
        $slots  = $config?->generateSlots() ?: [];

        $map = [];
        $idx = 0;
        foreach ($slots as $slot) {
            if ($slot['break'] ?? false) continue;
            $idx++;
            $name = explode('–', $slot['time'])[0] ?? null;
            if ($name) $map[$name] = $idx;
        }
        return $map;
    }

    /**
     * Build a "FET name -> 1-based position" lookup table from a SimpleXML list.
     */
    private function buildPositionIndex($iterable, string $field): array
    {
        $map = [];
        if (! $iterable) return $map;
        $i = 1;
        foreach ($iterable as $node) {
            $name = (string) $node->{$field};
            if ($name !== '') $map[$name] = $i;
            $i++;
        }
        return $map;
    }
}
