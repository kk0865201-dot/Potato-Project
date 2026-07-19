<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('varieties', function (Blueprint $table) {
            $table->json('translations')->nullable()->after('rating');
        });

        Schema::table('recipes', function (Blueprint $table) {
            $table->json('translations')->nullable()->after('steps');
        });
    }

    public function down(): void
    {
        Schema::table('varieties', fn (Blueprint $table) => $table->dropColumn('translations'));
        Schema::table('recipes', fn (Blueprint $table) => $table->dropColumn('translations'));
    }
};
