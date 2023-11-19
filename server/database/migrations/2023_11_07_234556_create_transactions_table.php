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
        Schema::create('transactions', function (Blueprint $table) {
            $table->id();
            $table->foreignUuid('user_id')->constrained('users')->onDelete('cascade');
            $table->enum('payment_method', ['Cash', 'CreditCard', 'DebitCard']);
            $table->string('payment_proof');
            $table->date('payment_date');
            $table->bigInteger('total');
            $table->enum('status', ['OnGoing', 'Pending', 'Rejected', 'Verified', 'Finished'])->default('OnGoing');
            $table->foreignUuid('verified_by')->nullable()->constrained('admins')->onDelete('cascade');
            $table->dateTime('verified_at')->nullable();
            $table->string('deliver_address');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('transactions');
    }
};
