<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('fetnet_client_config', function (Blueprint $table) {
            $table->id();
            $table->foreignId('client_id')->nullable()->constrained('fetnet_client')->nullOnDelete();
            $table->integer('number_of_days')->default(0);
            $table->integer('number_of_hours')->default(0);
            $table->time('start_time')->default('07:00');
            $table->smallInteger('slot_duration')->default(50); // minutes
            $table->time('break_start')->default('12:00');
            $table->time('break_end')->default('13:00');
            $table->boolean('no_break')->default(false);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('fetnet_client_config');
    }
};
