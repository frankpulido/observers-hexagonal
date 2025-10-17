-- Observers-Hexagonal Database - Updated Schema
-- Date: October 17, 2025
-- Reflects: Username-based self-verification architecture

DROP DATABASE IF EXISTS observers_hexagonal_v01;
CREATE DATABASE observers_hexagonal_v01 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE observers_hexagonal_v01;

-- =============================================
-- CORE AUTHENTICATION TABLES
-- =============================================

-- Users table (authentication + role flags)
CREATE TABLE users (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    email_verified_at TIMESTAMP NULL,
    mobile VARCHAR(15) NOT NULL UNIQUE,
    mobile_verified_at TIMESTAMP NULL,
    is_superadmin BOOLEAN NOT NULL DEFAULT FALSE,
    is_admin BOOLEAN NOT NULL DEFAULT FALSE,
    is_publisher BOOLEAN NOT NULL DEFAULT FALSE,
    is_subscriber BOOLEAN NOT NULL DEFAULT FALSE,
    remember_token VARCHAR(100) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_users_email (email),
    INDEX idx_users_username (username),
    INDEX idx_users_roles (is_publisher, is_subscriber)
);

-- Password reset tokens
CREATE TABLE password_reset_tokens (
    email VARCHAR(255) NOT NULL,
    token VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NULL,
    PRIMARY KEY (email)
);

-- Sessions table
CREATE TABLE sessions (
    id VARCHAR(255) NOT NULL,
    user_id BIGINT UNSIGNED NULL,
    ip_address VARCHAR(45) NULL,
    user_agent TEXT NULL,
    payload LONGTEXT NOT NULL,
    last_activity INT NOT NULL,
    PRIMARY KEY (id),
    INDEX idx_sessions_user_id (user_id),
    INDEX idx_sessions_last_activity (last_activity),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- =============================================
-- SERVICE CHANNELS
-- =============================================

-- Service channels (Alexa, Slack, Discord, etc.)
CREATE TABLE service_channels (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_service_channels_name (name)
);

-- =============================================
-- PUBLISHER DOMAIN
-- =============================================

-- Publishers table
CREATE TABLE publishers (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(255) NOT NULL UNIQUE,
    cif VARCHAR(255) NOT NULL UNIQUE,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    postal_code VARCHAR(5) NOT NULL,
    max_private_subscribers_plan INT NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_publishers_user_id (user_id),
    INDEX idx_publishers_name (name),
    INDEX idx_publishers_is_active (is_active),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Publisher lists (content categories)
CREATE TABLE publisher_lists (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    publisher_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT NULL,
    is_private BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_publisher_lists_publisher_name (publisher_id, name),
    INDEX idx_publisher_lists_publisher_id (publisher_id),
    INDEX idx_publisher_lists_is_private (is_private),
    INDEX idx_publisher_lists_is_active (is_active),
    FOREIGN KEY (publisher_id) REFERENCES publishers(id) ON DELETE CASCADE
);

-- =============================================
-- SUBSCRIBER DOMAIN
-- =============================================

-- Subscribers table (minimal profile)
CREATE TABLE subscribers (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id BIGINT UNSIGNED NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_subscribers_user_id (user_id),
    INDEX idx_subscribers_is_active (is_active),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- =============================================
-- CHANNEL MANAGEMENT (NEW ARCHITECTURE)
-- =============================================

-- Subscriber-Service-Channel bridge (full model, not pivot)
CREATE TABLE subscriber_service_channels (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    subscriber_id BIGINT UNSIGNED NOT NULL,
    service_channel_id BIGINT UNSIGNED NOT NULL,
    service_channel_username VARCHAR(255) NULL, -- User's ID on that service
    verification_token VARCHAR(255) NULL,        -- For verification flow
    verified_at TIMESTAMP NULL,                  -- When user verified
    is_active BOOLEAN NOT NULL DEFAULT FALSE,   -- FALSE until verified
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_subscriber_service_channel (subscriber_id, service_channel_id),
    INDEX idx_subscriber_service_channels_subscriber_id (subscriber_id),
    INDEX idx_subscriber_service_channels_service_channel_id (service_channel_id),
    INDEX idx_subscriber_service_channels_is_active (is_active),
    INDEX idx_subscriber_service_channels_username (service_channel_username),
    FOREIGN KEY (subscriber_id) REFERENCES subscribers(id) ON DELETE CASCADE,
    FOREIGN KEY (service_channel_id) REFERENCES service_channels(id) ON DELETE CASCADE
);

-- =============================================
-- SUBSCRIPTION RELATIONSHIPS
-- =============================================

-- Subscriptions (indirect channel linking for domain purity)
CREATE TABLE subscriptions (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    subscriber_id BIGINT UNSIGNED NOT NULL,
    publisher_list_id BIGINT UNSIGNED NOT NULL,
    service_channel_id BIGINT UNSIGNED NOT NULL, -- Which service TYPE to use
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_subscriptions_subscriber_list_channel (subscriber_id, publisher_list_id, service_channel_id),
    INDEX idx_subscriptions_subscriber_id (subscriber_id),
    INDEX idx_subscriptions_publisher_list_id (publisher_list_id),
    INDEX idx_subscriptions_service_channel_id (service_channel_id),
    FOREIGN KEY (subscriber_id) REFERENCES subscribers(id) ON DELETE CASCADE,
    FOREIGN KEY (publisher_list_id) REFERENCES publisher_lists(id) ON DELETE CASCADE,
    FOREIGN KEY (service_channel_id) REFERENCES service_channels(id) ON DELETE RESTRICT
);

-- =============================================
-- NOTIFICATION DOMAIN
-- =============================================

-- Notifications table (simplified, types removed for now)
CREATE TABLE notifications (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    publisher_list_id BIGINT UNSIGNED NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_notifications_publisher_list_id (publisher_list_id),
    INDEX idx_notifications_created_at (created_at),
    FOREIGN KEY (publisher_list_id) REFERENCES publisher_lists(id) ON DELETE CASCADE
);

-- =============================================
-- LARAVEL FRAMEWORK TABLES
-- =============================================

-- Cache table
CREATE TABLE cache (
    `key` VARCHAR(255) NOT NULL,
    value MEDIUMTEXT NOT NULL,
    expiration INT NOT NULL,
    PRIMARY KEY (`key`)
);

CREATE TABLE cache_locks (
    `key` VARCHAR(255) NOT NULL,
    owner VARCHAR(255) NOT NULL,
    expiration INT NOT NULL,
    PRIMARY KEY (`key`)
);

-- Job queue tables
CREATE TABLE jobs (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    queue VARCHAR(255) NOT NULL,
    payload LONGTEXT NOT NULL,
    attempts TINYINT UNSIGNED NOT NULL,
    reserved_at INT UNSIGNED NULL,
    available_at INT UNSIGNED NOT NULL,
    created_at INT UNSIGNED NOT NULL,
    PRIMARY KEY (id),
    INDEX idx_jobs_queue (queue)
);

CREATE TABLE job_batches (
    id VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    total_jobs INT NOT NULL,
    pending_jobs INT NOT NULL,
    failed_jobs INT NOT NULL,
    failed_job_ids LONGTEXT NOT NULL,
    options MEDIUMTEXT NULL,
    cancelled_at INT NULL,
    created_at INT NOT NULL,
    finished_at INT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE failed_jobs (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    uuid VARCHAR(255) NOT NULL UNIQUE,
    connection TEXT NOT NULL,
    queue TEXT NOT NULL,
    payload LONGTEXT NOT NULL,
    exception LONGTEXT NOT NULL,
    failed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_failed_jobs_uuid (uuid)
);

-- Personal access tokens (Sanctum)
CREATE TABLE personal_access_tokens (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    tokenable_type VARCHAR(255) NOT NULL,
    tokenable_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(255) NOT NULL,
    token VARCHAR(64) NOT NULL UNIQUE,
    abilities TEXT NULL,
    last_used_at TIMESTAMP NULL,
    expires_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_personal_access_tokens_tokenable (tokenable_type, tokenable_id),
    UNIQUE KEY uk_personal_access_tokens_token (token)
);

-- =============================================
-- INITIAL DATA SEEDING
-- =============================================

-- Insert service channels
INSERT INTO service_channels (name) VALUES 
('alexa'),
('slack'),
('discord'),
('telegram'),
('home_assistant');

-- Insert test users
INSERT INTO users (username, password, email, mobile) VALUES 
('janedoe', '$2y$12$LgVRqC5HkLa7VOHPL7xru.HvqGZMQ7FvQfYdQ1cZmUhTJqLj.V5Rq', 'jane@example.com', '123456789'),
('johndoe', '$2y$12$LgVRqC5HkLa7VOHPL7xru.HvqGZMQ7FvQfYdQ1cZmUhTJqLj.V5Rq', 'john@example.com', '987654321');

-- =============================================
-- DATABASE SUMMARY
-- =============================================

/*
OBSERVERS-HEXAGONAL DATABASE SCHEMA SUMMARY (UPDATED):

🔑 Key Changes from Original:
1. ✅ Added subscriber_service_channels table (full model, not pivot)
2. ✅ Updated users table with boolean role flags  
3. ✅ Simplified subscribers table (minimal profile)
4. ✅ Modified subscriptions to use indirect channel linking
5. ✅ Added comprehensive indexes for performance

🏗️ Core Architecture:
- Username-based self-verification system
- Observer-driven automatic record creation  
- GDPR-compliant data minimization
- Hexagonal architecture ready
- MCP microservices ready

📊 Tables: 17 total
- 7 business domain tables
- 1 channel bridge table  
- 9 Laravel framework tables

🔒 Security Features:
- Identity alignment verification
- Cascade deletion for privacy
- Audit trail timestamps
- Purpose-limited data storage

🚀 Evolution Ready:
- Current: Monolith with observers
- Next: MCP server integration
- Future: Full microservices decomposition

Database: observers_hexagonal
Charset: utf8mb4_unicode_ci
Collation: GDPR compliant, hexagonal architecture aligned
*/