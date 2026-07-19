<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('varieties', function (Blueprint $table) {
            $table->string('origin')->nullable()->after('best_for');
            $table->decimal('rating', 2, 1)->default(0)->after('origin');
        });
    }

    public function down(): void
    {
        Schema::table('varieties', function (Blueprint $table) {
            $table->dropColumn(['origin', 'rating']);
        });
    }
};
