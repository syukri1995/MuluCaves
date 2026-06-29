-- ============================================================
-- CSC584 Tourism Web App | Mulu Caves, Sarawak
-- Database schema + seed data
-- ============================================================
-- Run with: mysql -u root -p < db/schema.sql
-- ============================================================

CREATE DATABASE IF NOT EXISTS tourism_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE tourism_db;

-- ------------------------------------------------------------
-- Admin users (BCrypt-hashed passwords)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS admin_users (
  id         INT          AUTO_INCREMENT PRIMARY KEY,
  username   VARCHAR(50)  NOT NULL UNIQUE,
  password   VARCHAR(255) NOT NULL,
  created_at TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Public inquiries
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS inquiries (
  id           INT           AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(100)  NOT NULL,
  contact      VARCHAR(20)   NOT NULL,
  gender       ENUM('Male', 'Female', 'Other') NOT NULL,
  email        VARCHAR(150)  NOT NULL,
  heard_from   VARCHAR(100)  NOT NULL,
  message      TEXT          NOT NULL,
  submitted_at TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Activities shown on /activities
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS activities (
  id           INT          AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(120) NOT NULL,
  description  TEXT         NOT NULL,
  long_description TEXT,
  image_path   VARCHAR(255) NOT NULL,
  sort_order   INT          DEFAULT 0
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- Accommodation shown on /accommodation
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS accommodation (
  id           INT          AUTO_INCREMENT PRIMARY KEY,
  name         VARCHAR(120) NOT NULL,
  description  TEXT         NOT NULL,
  long_description TEXT,
  image_path   VARCHAR(255) NOT NULL,
  sort_order   INT          DEFAULT 0
) ENGINE=InnoDB;

-- ============================================================
-- Seed data
-- ============================================================

-- Default admin (username: admin / password: admin123)
-- Hash below is BCrypt strength 12, generated and verified. To rotate
-- the password: pick a new plaintext, run scripts/_gen_hash.py with
-- your new value, and update this row.
INSERT INTO admin_users (username, password) VALUES
('admin', '$2a$12$B35ig6ycr9hkxX85hdct9uOGh2SXRXsj8ML.t4CA17ZSJzpP1b38O');

INSERT INTO inquiries (name, contact, gender, email, heard_from, message) VALUES
('Ahmad Razif',   '0123456789', 'Male',   'ahmad@email.com',  'Social Media',  'When is the best season to visit Mulu Caves?'),
('Siti Nurfatin', '0198765432', 'Female', 'siti@email.com',   'Friend',        'Do you offer group packages?'),
('David Lim',     '0112233445', 'Male',   'david@email.com',  'Google Search', 'Is the canopy walk suitable for children?'),
('Nurul Ain',     '0167890123', 'Female', 'nurul@email.com',  'Travel Blog',   'What accommodation is available near the caves?');

INSERT INTO activities (name, description, image_path, sort_order) VALUES
('Deer Cave Exploration',     'Walk through one of the world''s largest cave passages and watch millions of bats stream out at dusk.', 'images/activities/activity-1.jpg', 1),
('Canopy Skywalk',            'Suspended 20 metres above the rainforest, the 480-metre skywalk offers a bird''s-eye view of the canopy.',   'images/activities/activity-2.jpg', 2),
('Headhunter''s Trail Trek',  'A guided jungle trek following a path once used by the Penan people — history, waterfalls, and biodiversity.', 'images/activities/activity-3.jpg', 3),
('Night River Cruise',        'Glide along the Melinau River at dusk to spot wildlife and the famous bat exodus against a fiery sky.',         'images/activities/activity-4.jpg', 4);

INSERT INTO accommodation (name, description, image_path, sort_order) VALUES
('Mulu Marriott Resort & Spa',      'Full-service resort with rainforest views, pool, and guided tours from the front desk.',         'images/accommodation/room-1.jpg', 1),
('Royal Mulu Resort',               'Comfortable mid-range stay within walking distance of park headquarters.',                       'images/accommodation/room-2.jpg', 2),
('Mulu National Park Hostel',       'Affordable dorm-style rooms run by Sarawak Forestry — the closest option to the caves.',          'images/accommodation/room-3.jpg', 3),
('Benarat Inn',                     'A quiet guesthouse catering to independent travellers looking for a homely base.',               'images/accommodation/room-4.jpg', 4);