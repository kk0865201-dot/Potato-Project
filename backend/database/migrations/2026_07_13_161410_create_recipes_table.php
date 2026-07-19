<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('recipes', function (Blueprint $table) {
            $table->id();
            $table->string('slug')->unique();
            $table->string('title');
            $table->string('summary');
            $table->string('tag_label');             // e.g. "Boil & mash"
            $table->string('tag_class')->nullable();
            $table->unsignedInteger('serves');
            $table->string('prep_time');
            $table->string('cook_time');
            $table->string('best_potato');
            $table->string('image');
            $table->string('image_alt');
            $table->json('ingredients');
            $table->json('steps');
            $table->boolean('featured')->default(false);
            $table->unsignedInteger('sort_order')->default(0);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('recipes');
    }
};
