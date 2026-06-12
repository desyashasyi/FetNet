<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('fetnet_timetable_slot', function (Blueprint $table) {
            $table->id();
            $table->foreignId('client_id')->constrained('fetnet_client')->cascadeOnDelete();
            $table->foreignId('semester_id')->constrained('fetnet_semester')->cascadeOnDelete();
            $table->foreignId('activity_id')->constrained('fetnet_activity')->cascadeOnDelete();
            $table->unsignedSmallInteger('day_index')->nullable();
            $table->unsignedSmallInteger('hour_index')->nullable();
            $table->foreignId('room_id')->nullable()->constrained('fetnet_space')->nullOnDelete();
            $table->boolean('locked')->default(true);
            $table->unsignedTinyInteger('weight_percent')->default(100);
            $table->timestamps();

            $table->unique(['client_id', 'semester_id', 'activity_id'], 'tt_slot_uniq');
            $table->index(['client_id', 'semester_id', 'locked'], 'tt_slot_lookup');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('fetnet_timetable_slot');
    }
};
