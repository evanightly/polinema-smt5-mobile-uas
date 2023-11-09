<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('cars', function (Blueprint $table) {
            $table->id();
            $table->string('name')->nullable(false);
            $table->foreignId('brand_id')->constrained('car_brands');
            $table->foreignId('body_type_id')->constrained('car_body_types');
            $table->integer('year')->nullable(false);
            $table->integer('km_min')->nullable(false); // 'km_min' and 'km_max' are used to determine the range of km
            $table->integer('km_max')->nullable(false);
            $table->foreignId('fuel_id')->constrained('car_fuels');
            $table->integer('price')->nullable(false);
            $table->string('image');
            $table->enum('condition', ['Used', 'New'])->nullable(false);
            $table->enum('transmission', ['Automatic', 'Manual'])->nullable(false);
            $table->enum('status', ['Available', 'Sold'])->nullable(false);
            $table->text('description');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cars');
    }
};
