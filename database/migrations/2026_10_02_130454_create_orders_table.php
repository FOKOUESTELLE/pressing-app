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
        Schema::create('orders', function (Blueprint $table) {
            $table->id();

            $table->string('order_number')->unique();
            $table->dateTime('order_date');

            $table->string('pickup_address')->nullable();
            $table->string('delivery_address')->nullable();

            $table->enum('recovery_mode', ['ON_SITE', 'DELIVERY']);
            $table->string('status')->default('PENDING');

            $table->unsignedInteger('delivery_fee')->default(0);
            $table->unsignedInteger('total')->default(0);

            $table->foreignId('customer_id')
                ->constrained('users')
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
        Schema::dropIfExists('orders');
    }
};
