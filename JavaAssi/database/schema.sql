-- =============================================================
--  Ocean View Resort - Hotel Reservation System
--  Database Schema & Seed Data
--  Author : IT Lecturer Demo
--  Usage  : Run this script once in MySQL before starting Tomcat
-- =============================================================

-- Create and select the database
CREATE DATABASE IF NOT EXISTS ocean_view_resort
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE ocean_view_resort;

-- =============================================================
-- TABLE 1: users  (staff who log in to the system)
-- =============================================================
CREATE TABLE IF NOT EXISTS users (
    id            INT          AUTO_INCREMENT PRIMARY KEY,
    username      VARCHAR(50)  NOT NULL UNIQUE,
    password      VARCHAR(100) NOT NULL,   -- stored as plain text for demo; use hashing in production
    full_name     VARCHAR(100) NOT NULL,
    role          VARCHAR(20)  NOT NULL DEFAULT 'STAFF',  -- ADMIN or STAFF
    created_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

-- Dummy staff accounts
-- Password for both accounts is: admin123
INSERT INTO users (username, password, full_name, role) VALUES
    ('admin',  'admin123',  'Admin User',    'ADMIN'),
    ('staff1', 'admin123',  'John Fernando', 'STAFF'),
    ('staff2', 'admin123',  'Priya Perera',  'STAFF');


-- =============================================================
-- TABLE 2: rooms  (room catalogue with rates)
-- =============================================================
CREATE TABLE IF NOT EXISTS rooms (
    id            INT            AUTO_INCREMENT PRIMARY KEY,
    room_number   VARCHAR(10)    NOT NULL UNIQUE,
    room_type     VARCHAR(50)    NOT NULL,   -- Standard, Deluxe, Suite, Ocean View
    rate_per_night DECIMAL(10,2) NOT NULL,
    description   VARCHAR(255),
    is_available  TINYINT(1)     NOT NULL DEFAULT 1   -- 1 = available, 0 = occupied
);

-- Dummy rooms
INSERT INTO rooms (room_number, room_type, rate_per_night, description, is_available) VALUES
    ('101', 'Standard',   5000.00,  'Comfortable room with garden view',          1),
    ('102', 'Standard',   5000.00,  'Comfortable room with garden view',          1),
    ('201', 'Deluxe',     8500.00,  'Spacious room with balcony and pool view',   1),
    ('202', 'Deluxe',     8500.00,  'Spacious room with balcony and pool view',   1),
    ('301', 'Suite',     15000.00,  'Luxury suite with living area',              1),
    ('302', 'Suite',     15000.00,  'Luxury suite with living area',              1),
    ('401', 'Ocean View',12000.00,  'Premium room with direct ocean view',        1),
    ('402', 'Ocean View',12000.00,  'Premium room with direct ocean view',        1);


-- =============================================================
-- TABLE 3: reservations  (all booking records)
-- =============================================================
CREATE TABLE IF NOT EXISTS reservations (
    id                INT           AUTO_INCREMENT PRIMARY KEY,
    reservation_no    VARCHAR(20)   NOT NULL UNIQUE,     -- e.g. OVR-00001
    guest_name        VARCHAR(100)  NOT NULL,
    address           VARCHAR(255)  NOT NULL,
    contact_no        VARCHAR(20)   NOT NULL,
    room_id           INT           NOT NULL,
    check_in_date     DATE          NOT NULL,
    check_out_date    DATE          NOT NULL,
    total_cost        DECIMAL(12,2) DEFAULT 0.00,
    status            VARCHAR(20)   NOT NULL DEFAULT 'CONFIRMED', -- CONFIRMED, CHECKED_IN, CHECKED_OUT, CANCELLED
    created_by        INT           NOT NULL,             -- FK -> users.id
    created_at        TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id)   REFERENCES rooms(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);

-- Dummy reservations (2 historical + 2 current month for reports demo)
INSERT INTO reservations
    (reservation_no, guest_name, address, contact_no, room_id, check_in_date, check_out_date, total_cost, status, created_by)
VALUES
    ('OVR-00001', 'Kamal Perera',   '12, Galle Road, Colombo 3',      '0712345678', 1, '2026-02-10', '2026-02-13', 15000.00, 'CHECKED_OUT', 1),
    ('OVR-00002', 'Nimal Silva',    '45, Kandy Road, Matale',         '0771234567', 3, '2026-02-18', '2026-02-21', 25500.00, 'CHECKED_OUT', 2),
    ('OVR-00003', 'Sunethra Gunasekara', '78, Temple Street, Galle',  '0812233445', 5, '2026-03-01', '2026-03-05', 60000.00, 'CONFIRMED',   1),
    ('OVR-00004', 'Raveendra Dissanayake','99, Main Street, Kurunegala','0765544332',7, '2026-03-03', '2026-03-07', 48000.00, 'CONFIRMED',   2);
