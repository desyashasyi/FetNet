<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('fetnet_semester', function (Blueprint $table) {
            $table->id();
            $table->foreignId('client_id')->nullable()->constrained('fetnet_client')->nullOnDelete();
            $table->foreignId('academic_year_id')->nullable()->constrained('fetnet_academic_year')->nullOnDelete();
            $table->string('name', 50)->nullable();
            $table->unsignedTinyInteger('start_month')->nullable();
            $table->unsignedTinyInteger('end_month')->nullable();
            $table->date('lecture_start')->nullable();
            $table->date('lecture_end')->nullable();
            $table->smallInteger('year')->nullable();
            $table->tinyInteger('semester')->nullable();
            $table->boolean('is_active')->default(false);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('fetnet_semester');
    }
};
