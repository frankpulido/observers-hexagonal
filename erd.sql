-- Observers-Hexagonal Database Creation Script
-- Generated from Laravel Models and Migrations
-- Date: October 16, 2025

DROP DATABASE IF EXISTS observers_hexagonal;
CREATE DATABASE observers_hexagonal CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE observers_hexagonal;

-- =============================================
-- CORE AUTHENTICATION TABLES
-- =============================================

-- Users table (core authentication)
CREATE TABLE users (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    email_verified_at TIMESTAMP NULL,
    mobile VARCHAR(15) NOT NULL UNIQUE,
    mobile_verified_at TIMESTAMP NULL,
    role ENUM('superadmin', 'admin', 'publisher', 'subscriber') NULL,
    password VARCHAR(255) NOT NULL,
    remember_token VARCHAR(100) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_users_email (email),
    INDEX idx_users_username (username),
    INDEX idx_users_role (role)
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

-- Service channels (Alexa, Slack, Discord, WhatsApp, etc.)
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

-- Subscribers table
CREATE TABLE subscribers (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id BIGINT UNSIGNED NOT NULL,
    subscriber_channels JSON NOT NULL, -- Channel preferences as JSON
    subscriber_email VARCHAR(255) NOT NULL UNIQUE,
    subscriber_mobile VARCHAR(255) NOT NULL UNIQUE,
    city VARCHAR(255) NULL,
    is_active BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    INDEX idx_subscribers_user_id (user_id),
    INDEX idx_subscribers_email (subscriber_email),
    INDEX idx_subscribers_is_active (is_active),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- =============================================
-- SUBSCRIPTION RELATIONSHIPS
-- =============================================

-- Subscriptions (many-to-many: subscribers to publisher_lists)
CREATE TABLE subscriptions (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    subscriber_id BIGINT UNSIGNED NOT NULL,
    publisher_list_id BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_subscriptions_subscriber_list (subscriber_id, publisher_list_id),
    INDEX idx_subscriptions_subscriber_id (subscriber_id),
    INDEX idx_subscriptions_publisher_list_id (publisher_list_id),
    FOREIGN KEY (subscriber_id) REFERENCES subscribers(id) ON DELETE CASCADE,
    FOREIGN KEY (publisher_list_id) REFERENCES publisher_lists(id) ON DELETE CASCADE
);

-- =============================================
-- NOTIFICATION DOMAIN
-- =============================================

-- Notifications table
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

-- Insert default service channels
INSERT INTO service_channels (name) VALUES 
('alexa'),
('home_assistant'),
('slack'),
('discord'),
('whatsapp'),
('telegram');

-- =============================================
-- DATABASE SUMMARY
-- =============================================

/*
OBSERVERS-HEXAGONAL DATABASE SCHEMA SUMMARY:

Core Tables:
- users: Authentication (admin, publisher, subscriber roles)
- service_channels: Available notification channels

Publisher Domain:
- publishers: Business entities
- publisher_lists: Content categories (public/private)

Subscriber Domain:  
- subscribers: User profiles + channel preferences (JSON)
- subscriptions: Many-to-many link (subscriber → publisher_list)

Notification Domain:
- notifications: Messages sent to publisher lists

Key Features:
✓ Username-based authentication (no OAuth)
✓ Dual roles (users can be both publisher AND subscriber)
✓ JSON channel preferences for flexibility
✓ Public/private publisher lists
✓ Proper foreign key constraints
✓ Optimized indexes for performance
✓ Laravel framework compatibility

Database: observers_hexagonal
Charset: utf8mb4_unicode_ci
Tables: 15 total (10 business + 5 framework)
*/