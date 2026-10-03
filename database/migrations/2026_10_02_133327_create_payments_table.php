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
        Schema::create('payments', function (Blueprint $table) {
            $table->id();
            $table->unsignedInteger('amount');
            $table->dateTime('payment_date');
            $table->enum('payment_method', ['CASH', 'MOBILE_MONEY', 'CARD']);
            $table->string('status')->default('PENDING');

            $table->foreignId('order_id')
                ->constrained('orders')
                ->restrictOnDelete();

            $table->timestamps();
            $table->softDeletes();
            $table->index('status');
            
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('payments');
    }
};
