<?php

namespace App\Imports\FetNet;

use App\Models\FetNet\CurriculumYear;
use App\Models\FetNet\Specialization;
use App\Models\FetNet\Subject;
use App\Models\FetNet\SubjectType;
use App\Support\CodeGenerator;
use Illuminate\Support\Collection;
use Maatwebsite\Excel\Concerns\ToCollection;
use Maatwebsite\Excel\Concerns\WithHeadingRow;

class SubjectImport implements ToCollection, WithHeadingRow
{
    public int $programId;
    public int $imported = 0;
    public int $skipped  = 0;

    public function __construct(int $programId)
    {
        $this->programId = $programId;
    }

    public function collection(Collection $rows): void
    {
        // Pre-load lookups
        $curriculumYears   = CurriculumYear::where('program_id', $this->programId)
            ->get()->keyBy(fn($y) => strtolower(trim($y->year)));

        // Index by both code and name for flexible matching
        $specializations = [];
        Specialization::where('program_id', $this->programId)->get()
            ->each(function ($s) use (&$specializations) {
                if ($s->code) $specializations[strtolower(trim($s->code))] = $s;
                if ($s->name) $specializations[strtolower(trim($s->name))] = $s;
            });

        $subjectTypes = [];
        SubjectType::where('program_id', $this->programId)->get()
            ->each(function ($t) use (&$subjectTypes) {
                if ($t->code) $subjectTypes[strtolower(trim($t->code))] = $t;
                if ($t->name) $subjectTypes[strtolower(trim($t->name))] = $t;
            });

        foreach ($rows as $row) {
            $code = trim($row['code'] ?? '');
            $name = trim($row['name'] ?? '');

            if ($code === '' || $name === '') {
                $this->skipped++;
                continue;
            }


            // Resolve curriculum_year_id: match by year string, auto-create if not found
            $curriculumYearId = null;
            $yearRaw = trim($row['curriculum_year'] ?? '');
            if ($yearRaw !== '') {
                $key = strtolower($yearRaw);
                if (! isset($curriculumYears[$key])) {
                    $cy = CurriculumYear::firstOrCreate(
                        ['program_id' => $this->programId, 'year' => $yearRaw]
                    );
                    $curriculumYears[$key] = $cy;
                }
                $curriculumYearId = $curriculumYears[$key]->id;
            }

            // Resolve specialization_id by code — auto-create if not found
            $specializationId = null;
            $specRaw = trim($row['specialization'] ?? '');
            if ($specRaw !== '') {
                $key = strtolower($specRaw);
                if (! isset($specializations[$key])) {
                    $spec = Specialization::firstOrCreate(
                        ['program_id' => $this->programId, 'code' => CodeGenerator::fromPhrase($specRaw)],
                        ['name' => $specRaw]
                    );
                    $specializations[$key]                         = $spec;
                    $specializations[strtolower(trim($spec->code))] = $spec;
                    $specializations[strtolower(trim($spec->name))] = $spec;
                }
                $specializationId = $specializations[$key]->id;
            }

            // Resolve type_id by code — auto-create if not found
            $typeId = null;
            $typeRaw = trim($row['type'] ?? '');
            if ($typeRaw !== '') {
                $key = strtolower($typeRaw);
                if (! isset($subjectTypes[$key])) {
                    $st = SubjectType::firstOrCreate(
                        ['program_id' => $this->programId, 'code' => CodeGenerator::fromPhrase($typeRaw)],
                        ['name' => $typeRaw]
                    );
                    $subjectTypes[$key]                          = $st;
                    $subjectTypes[strtolower(trim($st->code))]   = $st;
                    $subjectTypes[strtolower(trim($st->name))]   = $st;
                }
                $typeId = $subjectTypes[$key]->id;
            }

            Subject::withTrashed()->updateOrCreate(
                ['code' => $code, 'program_id' => $this->programId],
                [
                    'name'               => $name,
                    'credit'             => isset($row['credit'])   ? (int) $row['credit']   : 2,
                    'semester'           => isset($row['semester']) && $row['semester'] !== ''
                                            ? (int) $row['semester'] : null,
                    'curriculum_year_id' => $curriculumYearId,
                    'specialization_id'  => $specializationId,
                    'type_id'            => $typeId,
                    'deleted_at'         => null,
                ]
            );

            $this->imported++;
        }
    }
}
