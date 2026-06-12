<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('fetnet_fet_compile', function (Blueprint $table) {
            $table->id();
            $table->foreignId('client_id')->constrained('fetnet_client')->cascadeOnDelete();
            $table->foreignId('semester_id')->constrained('fetnet_semester')->cascadeOnDelete();
            $table->foreignId('user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->string('path')->nullable();
            $table->unsignedBigInteger('size_bytes')->nullable();
            $table->string('status')->default('pending');
            $table->text('message')->nullable();
            $table->unsignedInteger('duration_ms')->nullable();
            $table->string('solver_status')->nullable(); // pending|running|success|failed|stopped
            $table->string('solver_output_dir')->nullable();
            $table->string('solver_result_path')->nullable();
            $table->timestamp('solver_started_at')->nullable();
            $table->timestamp('solver_finished_at')->nullable();
            $table->unsignedInteger('solver_pid')->nullable();
            $table->text('solver_message')->nullable();
            $table->timestamp('published_at')->nullable();
            $table->foreignId('published_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamps();

            $table->index(['client_id', 'semester_id']);
            $table->index('status');
            $table->index('solver_status');
            $table->index(['client_id', 'semester_id', 'published_at'], 'fet_compile_publish_lookup');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('fetnet_fet_compile');
    }
};
