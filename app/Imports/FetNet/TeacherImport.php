<?php

namespace App\Imports\FetNet;

use App\Models\FetNet\Teacher;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\ToCollection;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

class TeacherImport implements ToCollection, WithHeadingRow
{
    public int   $imported    = 0;
    public int   $skipped     = 0;
    public int   $asGuest     = 0;
    public array $codeAutoGen = [];  // names whose code was auto-generated

    /**
     * @param array<string,int> $programMap        lowercase abbrev => program_id
     * @param int               $defaultProgramId  fallback when study_program is empty or not found
     */
    public function __construct(
        public array $programMap,
        public int   $defaultProgramId,
    ) {}

    public function collection(Collection $rows): void
    {
        $allProgramIds = array_values($this->programMap);

        // Pre-load all existing codes to avoid duplicates
        $usedCodes = Teacher::whereIn('program_id', $allProgramIds)
            ->whereNotNull('code')
            ->pluck('code')
            ->map(fn($c) => strtoupper($c))
            ->toArray();

        foreach ($rows as $row) {
            $name         = trim($row['name']          ?? '');
            $studyProgram = strtolower(trim($row['study_program'] ?? ''));
            $employeeId   = trim($row['employee_id']   ?? '');
            $univCode     = strtoupper(trim($row['univ_code']    ?? ''));

            if ($name === '') {
                $this->skipped++;
                continue;
            }

            // Resolve target program
            $programId = $this->programMap[$studyProgram] ?? $this->defaultProgramId;

            // ── Step 1: find existing teacher globally by employee_id / univ_code / name ──
            $existing = null;

            if ($employeeId !== '') {
                $existing = Teacher::withTrashed()->where('employee_id', $employeeId)->first();
            }
            if (! $existing && $univCode !== '') {
                $existing = Teacher::withTrashed()->where('univ_code', $univCode)->first();
            }
            if (! $existing) {
                $existing = Teacher::withTrashed()->where('name', $name)->first();
            }

            if ($existing) {
                // ── Found globally ──
                if ($existing->program_id !== $programId) {
                    // Different program → add as guest (if not already)
                    $existing->guestPrograms()->syncWithoutDetaching([$programId]);
                    $this->asGuest++;
                } else {
                    // Same program → update data
                    $existing->update($this->buildAttributes($row, $existing->code, $usedCodes, $name));
                    $this->imported++;
                }

                if ($existing->deleted_at) {
                    $existing->restore();
                }

                continue;
            }

            // ── Step 2: new teacher — resolve code ──
            $rawCode = strtoupper(trim($row['code'] ?? ''));
            if (strlen($rawCode) === 3 && ! in_array($rawCode, $usedCodes)) {
                $code = $rawCode;
            } else {
                $code = Teacher::generateCode($name, $usedCodes);
                $this->codeAutoGen[] = "{$name} → {$code}";
            }

            $usedCodes[] = $code;

            Teacher::create(array_merge(
                ['program_id' => $programId, 'code' => $code],
                $this->buildAttributes($row, $code, $usedCodes, $name)
            ));

            $this->imported++;
        }
    }

    private function buildAttributes(mixed $row, string $code, array $usedCodes, string $name): array
    {
        return [
            'code'        => $code,
            'name'        => $name,
            'univ_code'   => strtoupper(trim($row['univ_code']    ?? '')) ?: null,
            'employee_id' => trim($row['employee_id'] ?? '') ?: null,
            'position'    => trim($row['position']    ?? '') ?: null,
            'civil_grade' => trim($row['civil_grade'] ?? '') ?: null,
            'front_title' => trim($row['front_title'] ?? '') ?: null,
            'rear_title'  => trim($row['rear_title']  ?? '') ?: null,
            'email'       => trim($row['email']       ?? '') ?: null,
            'phone'       => trim($row['phone']       ?? '') ?: null,
            'deleted_at'  => null,
        ];
    }
}
