<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('fetnet_timetable_slot', function (Blueprint $table) {
            $table->unsignedTinyInteger('duration')->default(1)->after('hour_index');
        });
    }

    public function down(): void
    {
        Schema::table('fetnet_timetable_slot', function (Blueprint $table) {
            $table->dropColumn('duration');
        });
    }
};
