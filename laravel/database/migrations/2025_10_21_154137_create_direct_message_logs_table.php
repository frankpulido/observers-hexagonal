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
        Schema::create('direct_message_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('receiver_id')->constrained('subscribers')->onDelete('cascade');
            $table->foreignId('sender_id')->constrained('subscribers')->onDelete('cascade');
            $table->timestamp('sent_at')->useCurrent();
            $table->boolean('status')->default(false);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('direct_message_logs');
    }
};
