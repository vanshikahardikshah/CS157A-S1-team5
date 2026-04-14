-- NearFix Database Setup Script
-- Run this with MySQL root user to set up the database and user

-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS nearfix;

-- Use the database
USE nearfix;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    salt VARCHAR(64) NOT NULL,
    zip_code VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create User account if it doesn't exist
-- Note: This requires root or admin access
CREATE USER IF NOT EXISTS 'User'@'localhost' IDENTIFIED BY '';

-- Grant privileges to User account
GRANT ALL PRIVILEGES ON nearfix.* TO 'User'@'localhost';

-- Flush privileges
FLUSH PRIVILEGES;

-- Verify the setup
SELECT 'Database setup complete!' AS status;

