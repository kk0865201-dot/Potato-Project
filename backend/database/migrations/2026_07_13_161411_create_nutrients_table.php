<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('nutrients', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('amount');                          // display value, e.g. "0.2 g"
            $table->unsignedInteger('percent_dv')->nullable(); // % Daily Value when known
            $table->boolean('is_major')->default(false);       // bold row in the facts panel
            $table->boolean('is_thick')->default(false);       // thick divider on the row
            $table->boolean('indented')->default(false);       // sub-row (fibre, sugars)
            $table->boolean('show_bar')->default(false);       // shown in the %DV bar chart
            $table->unsignedInteger('sort_order')->default(0);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('nutrients');
    }
};
