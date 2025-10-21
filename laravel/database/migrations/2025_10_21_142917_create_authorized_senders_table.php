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
        Schema::create('authorized_senders', function (Blueprint $table) {
            $table->id();
            $table->foreignId('receiver_id')->constrained('subscribers')->onDelete('cascade');
            $table->foreignId('sender_id')->constrained('subscribers')->onDelete('cascade');
            $table->foreignId('subscriber_service_channel_id')->constrained('subscriber_service_channels')->onDelete('cascade');
            $table->unique(['receiver_id', 'sender_id'], 'unique_receiver_sender');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('authorized_senders');
    }
};
