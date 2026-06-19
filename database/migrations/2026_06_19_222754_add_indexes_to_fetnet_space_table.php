<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Index the columns the Assign Space room list filters and sorts on.
 *
 * The available/assigned room queries in assign-space-sheet always scope by
 * client_id and order by name; without a composite (client_id, name) index
 * MariaDB resolves them with a per-render filesort, which is the bulk of the
 * per-click "heaviness" when assigning/removing rooms. client_id alone already
 * has an FK index, but it does not cover the name ordering.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('fetnet_space', function (Blueprint $table) {
            $table->index(['client_id', 'name'], 'fetnet_space_client_name_idx');
        });
    }

    public function down(): void
    {
        Schema::table('fetnet_space', function (Blueprint $table) {
            $table->dropIndex('fetnet_space_client_name_idx');
        });
    }
};
