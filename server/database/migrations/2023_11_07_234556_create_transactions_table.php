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
            $table->enum('payment_method', ['Cash', 'CreditCard', 'DebitCard'])->nullable();
            $table->string('payment_proof')->nullable();
            $table->timestamp('payment_date')->useCurrent();
            $table->unsignedBigInteger('total')->default(0);
            $table->enum('status', ['Pending', 'Rejected', 'Verified', 'Finished'])->default('Pending');
            $table->foreignUuid('verified_by')->nullable()->constrained('admins')->onDelete('cascade');
            $table->timestamp('verified_at')->nullable();
            $table->string('delivery_address')->nullable();
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
