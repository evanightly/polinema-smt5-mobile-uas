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
            $table->string('name');
            $table->enum('brand', ['Toyota', 'Honda', 'Suzuki', 'Mitsubishi', 'Daihatsu', 'Mazda', 'Nissan', 'Mercedes-Benz', 'BMW', 'Audi', 'Lexus', 'Isuzu']);
            $table->enum('body_type', ['SUV', 'Sedan', 'Hatchback', 'MPV', 'Wagon']);
            $table->integer('year');
            $table->integer('km_min'); // 'km_min' and 'km_max' are used to determine the range of km
            $table->integer('km_max');
            $table->enum('fuel', ['Pertamax', 'Solar']);
            $table->integer('price');
            $table->string('image');
            $table->enum('condition', ['Used', 'New']);
            $table->enum('transmission', ['Automatic', 'Manual']);
            $table->enum('status', ['Available', 'Sold']);
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
