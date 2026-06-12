<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('fetnet_teacher_constraint', function (Blueprint $table) {
            $table->id();
            $table->foreignId('program_id')->constrained('institution_program')->cascadeOnDelete();
            $table->foreignId('teacher_id')->nullable()->constrained('fetnet_teacher')->nullOnDelete();
            $table->string('constraint_type');   // e.g. max_days_per_week
            $table->integer('value');
            $table->decimal('weight', 5, 2)->default(100.00);
            $table->foreignId('tag_id')->nullable()->constrained('fetnet_activity_tag')->nullOnDelete();
            $table->foreignId('tag2_id')->nullable()->constrained('fetnet_activity_tag')->nullOnDelete();
            $table->tinyInteger('interval_start')->nullable();
            $table->tinyInteger('interval_end')->nullable();
            $table->timestamps();

            $table->index('program_id', 'ftc_program_id_index');
            $table->index('teacher_id', 'ftc_teacher_id_index');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('fetnet_teacher_constraint');
    }
};
