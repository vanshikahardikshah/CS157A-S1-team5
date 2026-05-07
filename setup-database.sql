DROP DATABASE IF EXISTS nearfix;
CREATE DATABASE IF NOT EXISTS nearfix;
USE nearfix;

-- Create app database user with no password
CREATE USER IF NOT EXISTS 'nearfix_user'@'localhost';
GRANT ALL PRIVILEGES ON nearfix.* TO 'nearfix_user'@'localhost';


-- =========================
-- TABLES
-- =========================

CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    salt VARCHAR(64) NOT NULL,
    zip_code VARCHAR(10),
    role ENUM('customer', 'provider', 'admin') NOT NULL DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS providers (
    provider_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    business_name VARCHAR(150),
    contact_number VARCHAR(20),
    approval_status ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS service_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE IF NOT EXISTS services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    provider_id INT NOT NULL,
    category_id INT NOT NULL,
    service_name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    location_zip VARCHAR(10),
    FOREIGN KEY (provider_id) REFERENCES providers(provider_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES service_categories(category_id)
);

CREATE TABLE IF NOT EXISTS availability (
    availability_id INT AUTO_INCREMENT PRIMARY KEY,
    provider_id INT NOT NULL,
    available_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (provider_id) REFERENCES providers(provider_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    service_id INT NOT NULL,
    booking_date DATE NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled', 'completed') NOT NULL DEFAULT 'pending',
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(service_id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    card_last4 VARCHAR(4) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) NOT NULL,
    payment_status ENUM('completed', 'pending', 'failed') NOT NULL DEFAULT 'completed'
);

CREATE TABLE IF NOT EXISTS has_payment (
    booking_id INT NOT NULL,
    payment_id INT NOT NULL,
    PRIMARY KEY (booking_id, payment_id),
    UNIQUE KEY unique_booking_payment (booking_id),
    UNIQUE KEY unique_payment_booking (payment_id),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (payment_id) REFERENCES payments(payment_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    customer_id INT NOT NULL,
    provider_id INT NOT NULL,
    rating INT NOT NULL,
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (provider_id) REFERENCES providers(provider_id) ON DELETE CASCADE
);

-- =========================
-- SAMPLE DATA
-- =========================

-- USERS
INSERT IGNORE INTO users (user_id, name, email, password_hash, salt, zip_code, role) VALUES
(1, 'Aarav Patel', 'aarav@gmail.com', 'dummyhash', 'dummysalt', '95112', 'provider'),
(2, 'Riya Shah', 'riya@gmail.com', 'dummyhash', 'dummysalt', '95113', 'customer'),
(3, 'Mia Lopez', 'mia@gmail.com', 'dummyhash', 'dummysalt', '95116', 'provider'),
(4, 'Kabir Mehta', 'kabir@gmail.com', 'dummyhash', 'dummysalt', '95117', 'customer'),
(5, 'Plumbing Pro', 'plumbingpro@gmail.com', 'dummyhash', 'dummysalt', '95110', 'provider'),
(6, 'Bike Repair Hub', 'bikerepair@gmail.com', 'dummyhash', 'dummysalt', '95113', 'provider'),
(7, 'Admin User', 'admin@nearfix.com', 'dummyhash', 'dummysalt', '95112', 'admin'),
(8, 'Olivia Garcia', 'olivia@gmail.com', 'dummyhash', 'dummysalt', '95125', 'customer'),
(9, 'Noah Wilson', 'noah@gmail.com', 'dummyhash', 'dummysalt', '95122', 'customer'),
(10, 'Sophia Kim', 'sophia@gmail.com', 'dummyhash', 'dummysalt', '95123', 'customer'),
(11, 'Leo Sparks', 'leo@gmail.com', 'dummyhash', 'dummysalt', '95124', 'provider'),
(12, 'Emma FixIt', 'emma@gmail.com', 'dummyhash', 'dummysalt', '95118', 'provider'),
(13, 'Raj Repairs', 'raj@gmail.com', 'dummyhash', 'dummysalt', '95126', 'provider'),
(14, 'Nina Paints', 'nina@gmail.com', 'dummyhash', 'dummysalt', '95129', 'provider'),
(15, 'Omar Tech', 'omar@gmail.com', 'dummyhash', 'dummysalt', '95130', 'provider'),
(16, 'Chris Handy', 'chris@gmail.com', 'dummyhash', 'dummysalt', '95131', 'provider');

-- PROVIDERS
INSERT IGNORE INTO providers (provider_id, user_id, business_name, contact_number, approval_status) VALUES
(1, 1, 'Aarav Electricals', '4085552001', 'approved'),
(2, 3, 'Mia Cleaning Services', '4085552002', 'approved'),
(3, 5, 'Plumbing Pro', '4085552003', 'pending'),
(4, 6, 'Bike Repair Services', '4085552004', 'pending'),
(5, 11, 'Leo Gardening Co.', '4085552005', 'approved'),
(6, 12, 'Emma Appliance Repair', '4085552006', 'approved'),
(7, 13, 'Raj Moving Help', '4085552007', 'pending'),
(8, 14, 'Nina Painting Studio', '4085552008', 'approved'),
(9, 15, 'Omar Tech Support', '4085552009', 'approved'),
(10, 16, 'Chris Handy Services', '4085552010', 'pending');

-- SERVICE CATEGORIES
INSERT IGNORE INTO service_categories (category_id, category_name, description) VALUES
(1, 'Cleaning', 'Home and office cleaning services'),
(2, 'Electrical', 'Electrical repair and installation'),
(3, 'Plumbing', 'Pipe repairs and leak fixing'),
(4, 'Painting', 'Interior and exterior painting'),
(5, 'Technician', 'General repair and maintenance'),
(6, 'Gardening', 'Lawn care and gardening help'),
(7, 'Moving', 'Packing and moving assistance'),
(8, 'Appliance Repair', 'Repair services for household appliances'),
(9, 'Bike Repair', 'Bicycle repair and maintenance'),
(10, 'IT Support', 'Computer and network troubleshooting');

-- SERVICES
INSERT IGNORE INTO services (service_id, provider_id, category_id, service_name, description, price, location_zip) VALUES
(1, 1, 2, 'Electrical Repair', 'Repair outlets and switches', 130.00, '95112'),
(2, 2, 1, 'House Cleaning', 'Standard home cleaning service', 80.00, '95116'),
(3, 3, 3, 'Pipe Leak Fix', 'Fix leaking pipes and taps', 110.00, '95110'),
(4, 4, 9, 'Bike Tire Change', 'Bike tire replacement and tune-up', 45.00, '95113'),
(5, 5, 6, 'Garden Maintenance', 'Lawn mowing and trimming', 75.00, '95124'),
(6, 6, 8, 'Washing Machine Repair', 'Fix washer issues', 120.00, '95118'),
(7, 7, 7, 'Furniture Moving', 'Small apartment moving help', 150.00, '95126'),
(8, 8, 4, 'Interior Painting', 'Paint bedroom and living room walls', 200.00, '95129'),
(9, 9, 10, 'Laptop Setup', 'Software installation and troubleshooting', 95.00, '95130'),
(10, 10, 5, 'General Handyman', 'Minor home repair and maintenance', 90.00, '95131');

-- AVAILABILITY
INSERT IGNORE INTO availability (availability_id, provider_id, available_date, start_time, end_time) VALUES
(1, 1, '2026-05-10', '09:00:00', '12:00:00'),
(2, 2, '2026-05-10', '10:00:00', '13:00:00'),
(3, 3, '2026-05-11', '08:00:00', '11:00:00'),
(4, 4, '2026-05-11', '12:00:00', '15:00:00'),
(5, 5, '2026-05-12', '09:00:00', '12:00:00'),
(6, 6, '2026-05-12', '13:00:00', '16:00:00'),
(7, 7, '2026-05-13', '10:00:00', '14:00:00'),
(8, 8, '2026-05-13', '09:00:00', '11:00:00'),
(9, 9, '2026-05-14', '11:00:00', '14:00:00'),
(10, 10, '2026-05-14', '15:00:00', '18:00:00');

-- BOOKINGS
INSERT IGNORE INTO bookings (booking_id, customer_id, service_id, booking_date, status, total_price) VALUES
(1, 2, 1, '2026-05-10', 'pending', 130.00),
(2, 4, 2, '2026-05-10', 'confirmed', 80.00),
(3, 8, 3, '2026-05-11', 'pending', 110.00),
(4, 9, 4, '2026-05-11', 'completed', 45.00),
(5, 10, 5, '2026-05-12', 'pending', 75.00),
(6, 2, 6, '2026-05-12', 'cancelled', 120.00),
(7, 4, 7, '2026-05-13', 'confirmed', 150.00),
(8, 8, 8, '2026-05-13', 'pending', 200.00),
(9, 9, 9, '2026-05-14', 'completed', 95.00),
(10, 10, 10, '2026-05-14', 'pending', 90.00);

-- PAYMENTS
INSERT IGNORE INTO payments (payment_id, card_last4, payment_method, payment_date, amount, payment_status) VALUES
(1, '1111', 'credit_card', '2026-05-10 08:30:00', 130.00, 'completed'),
(2, '2222', 'credit_card', '2026-05-10 09:15:00', 80.00, 'completed'),
(3, '3333', 'credit_card', '2026-05-11 08:00:00', 110.00, 'completed'),
(4, '4444', 'credit_card', '2026-05-11 11:30:00', 45.00, 'completed'),
(5, '5555', 'credit_card', '2026-05-12 08:45:00', 75.00, 'completed'),
(6, '6666', 'credit_card', '2026-05-12 12:30:00', 120.00, 'completed'),
(7, '7777', 'credit_card', '2026-05-13 09:30:00', 150.00, 'completed'),
(8, '8888', 'credit_card', '2026-05-13 08:30:00', 200.00, 'completed'),
(9, '9999', 'credit_card', '2026-05-14 10:30:00', 95.00, 'completed'),
(10, '1010', 'credit_card', '2026-05-14 14:30:00', 90.00, 'completed');

-- HAS PAYMENT RELATIONSHIP
INSERT IGNORE INTO has_payment (booking_id, payment_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- REVIEWS
INSERT IGNORE INTO reviews (review_id, booking_id, customer_id, provider_id, rating, comment) VALUES
(1, 1, 2, 1, 5, 'Great electrical repair service'),
(2, 2, 4, 2, 4, 'Very clean and professional'),
(3, 3, 8, 3, 5, 'Quick plumbing fix'),
(4, 4, 9, 4, 4, 'Bike repair was good'),
(5, 5, 10, 5, 5, 'Garden looked amazing'),
(6, 6, 2, 6, 3, 'Repair was okay'),
(7, 7, 4, 7, 4, 'Moving service was helpful'),
(8, 8, 8, 8, 5, 'Painting work was excellent'),
(9, 9, 9, 9, 4, 'Laptop setup done well'),
(10, 10, 10, 10, 5, 'Very useful handyman service');