<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('varieties', function (Blueprint $table) {
            $table->id();
            $table->string('slug')->unique();
            $table->string('name');
            $table->string('type');                      // Starchy | Waxy | All-purpose
            $table->string('tag_class')->nullable();     // extra CSS class for the tag pill
            $table->text('description');
            $table->string('best_for');
            $table->string('image');                     // path under public/, e.g. assets/photos/russet.jpg
            $table->string('image_alt');
            $table->boolean('featured')->default(false); // shown on the home page preview
            $table->unsignedInteger('sort_order')->default(0);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('varieties');
    }
};
