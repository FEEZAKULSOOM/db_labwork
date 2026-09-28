-- ============================================================
-- CAR RENTAL MANAGEMENT SYSTEM
-- Database Systems - Open Ended Lab
-- University of Azad Jammu & Kashmir, Muzaffarabad
-- Student: Feeza Kulsoom
-- Roll No: 2024-SE-03
-- Reg No: 2024-UMDB-004738
-- ============================================================

-- ============================================================
-- TASK 1: DATABASE CREATION
-- ============================================================

DROP DATABASE IF EXISTS CarRentalDB;

CREATE DATABASE CarRentalDB;

USE CarRentalDB;


-- ============================================================
-- TASK 1: TABLE CREATION
-- ============================================================

-- Customer Table
CREATE TABLE Customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE
);


-- Vehicle Table
CREATE TABLE Vehicle (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_number VARCHAR(50) NOT NULL UNIQUE,
    model VARCHAR(100) NOT NULL,
    daily_rate DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Available',

    CONSTRAINT chk_vehicle_rate
        CHECK (daily_rate > 0),

    CONSTRAINT chk_vehicle_status
        CHECK (status IN ('Available', 'Rented', 'Maintenance'))
);


-- Rental Table
CREATE TABLE Rental (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    rental_date DATE NOT NULL,
    return_date DATE NOT NULL,
    total_charge DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active',

    CONSTRAINT fk_rental_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id),

    CONSTRAINT fk_rental_vehicle
        FOREIGN KEY (vehicle_id)
        REFERENCES Vehicle(vehicle_id),

    CONSTRAINT chk_rental_dates
        CHECK (return_date >= rental_date),

    CONSTRAINT chk_rental_charge
        CHECK (total_charge >= 0),

    CONSTRAINT chk_rental_status
        CHECK (status IN ('Active', 'Completed', 'Cancelled'))
);


-- Payment Table
CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(20) NOT NULL DEFAULT 'Paid',

    CONSTRAINT fk_payment_rental
        FOREIGN KEY (rental_id)
        REFERENCES Rental(rental_id),

    CONSTRAINT chk_payment_amount
        CHECK (amount > 0),

    CONSTRAINT chk_payment_status
        CHECK (payment_status IN ('Paid', 'Pending', 'Refunded'))
);


-- ============================================================
-- TASK 1: SAMPLE DATA
-- ============================================================

-- Customer Sample Data
INSERT INTO Customer (name, phone, email) VALUES
('Usman Khan', '0300-1234567', 'usman@gmail.com'),
('Ayesha Malik', '0311-9876543', 'ayesha@gmail.com'),
('Ali Hassan', '0322-5551234', 'ali@gmail.com'),
('Zainab Bibi', '0333-4445556', 'zainab@gmail.com'),
('Hamza Ahmed', '0345-7778899', 'hamza@gmail.com');


-- Vehicle Sample Data
INSERT INTO Vehicle
(vehicle_number, model, daily_rate, status)
VALUES
('ABC-123', 'Toyota Corolla', 5000.00, 'Rented'),
('XYZ-789', 'Honda Civic', 6000.00, 'Available'),
('LHR-456', 'Suzuki Alto', 3000.00, 'Available'),
('KHI-999', 'Kia Sportage', 9000.00, 'Maintenance'),
('ISB-555', 'Toyota Yaris', 4500.00, 'Available');


-- Rental Sample Data
INSERT INTO Rental
(customer_id, vehicle_id, rental_date, return_date, total_charge, status)
VALUES
(1, 1, '2026-09-11', '2026-09-14', 15000.00, 'Active'),
(2, 2, '2026-09-01', '2026-09-05', 24000.00, 'Completed'),
(1, 3, '2026-08-20', '2026-08-22', 6000.00, 'Completed');


-- Payment Sample Data
INSERT INTO Payment
(rental_id, payment_date, amount, payment_status)
VALUES
(1, '2026-09-11', 15000.00, 'Paid'),
(2, '2026-09-05', 24000.00, 'Paid'),
(3, '2026-08-22', 6000.00, 'Paid');


-- ============================================================
-- OPTIONAL VERIFICATION: TABLE DATA
-- ============================================================

SELECT * FROM Customer;
SELECT * FROM Vehicle;
SELECT * FROM Rental;
SELECT * FROM Payment;


-- ============================================================
-- TASK 3: JOIN QUERIES
-- ============================================================

-- ============================================================
-- QUERY 1: Display Every Rental
-- Screenshot 1: Capture the result of this query.
-- ============================================================

SELECT
    c.name AS CustomerName,
    v.vehicle_number AS VehicleNumber,
    v.model AS VehicleModel,
    r.rental_date AS RentalDate,
    r.return_date AS ReturnDate
FROM Rental r
INNER JOIN Customer c
    ON r.customer_id = c.customer_id
INNER JOIN Vehicle v
    ON r.vehicle_id = v.vehicle_id;


-- ============================================================
-- QUERY 2: All Customers and Their Rented Vehicles
-- Screenshot 2: Capture the result of this query.
-- Customers without rentals should show NULL vehicle fields.
-- ============================================================

SELECT
    c.customer_id AS CustomerID,
    c.name AS CustomerName,
    v.vehicle_number AS VehicleNumber,
    v.model AS VehicleModel
FROM Customer c
LEFT JOIN Rental r
    ON c.customer_id = r.customer_id
LEFT JOIN Vehicle v
    ON r.vehicle_id = v.vehicle_id;


-- ============================================================
-- QUERY 3: All Vehicles and Current Rental Information
-- Screenshot 3: Capture the result of this query.
-- Only Active rentals are treated as current rentals.
-- ============================================================

SELECT
    v.vehicle_id AS VehicleID,
    v.vehicle_number AS VehicleNumber,
    v.model AS Model,
    v.status AS CurrentStatus,
    r.rental_id AS RentalID,
    r.rental_date AS RentalDate,
    r.return_date AS ReturnDate
FROM Vehicle v
LEFT JOIN Rental r
    ON v.vehicle_id = r.vehicle_id
    AND r.status = 'Active';


-- ============================================================
-- QUERY 4: Total Rentals per Customer
-- Screenshot 4: Capture the result of this query.
-- Customers with no rentals should receive 0.
-- ============================================================

SELECT
    c.customer_id AS CustomerID,
    c.name AS CustomerName,
    COUNT(r.rental_id) AS TotalRentals
FROM Customer c
LEFT JOIN Rental r
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.name
ORDER BY c.customer_id;


-- ============================================================
-- TASK 4: DATABASE VIEW
-- ============================================================

-- Remove the view if it already exists.
DROP VIEW IF EXISTS vw_ConsolidatedRentalReport;


-- Create consolidated rental report view.
CREATE VIEW vw_ConsolidatedRentalReport AS
SELECT
    r.rental_id AS RentalID,
    c.name AS CustomerName,
    c.phone AS CustomerPhone,
    v.vehicle_number AS VehicleNumber,
    v.model AS VehicleModel,
    r.rental_date AS RentalDate,
    r.return_date AS ReturnDate,
    r.total_charge AS TotalCharge,
    p.payment_status AS PaymentStatus
FROM Rental r
INNER JOIN Customer c
    ON r.customer_id = c.customer_id
INNER JOIN Vehicle v
    ON r.vehicle_id = v.vehicle_id
LEFT JOIN Payment p
    ON r.rental_id = p.rental_id;


-- Screenshot 5: Capture the view output.
SELECT * FROM vw_ConsolidatedRentalReport;


-- ============================================================
-- TASK 5: STORED PROCEDURE
-- ============================================================

-- Remove the procedure if it already exists.
DROP PROCEDURE IF EXISTS sp_RegisterNewRental;

DELIMITER //

CREATE PROCEDURE sp_RegisterNewRental(
    IN p_customer_id INT,
    IN p_vehicle_id INT,
    IN p_rental_date DATE,
    IN p_return_date DATE
)
BEGIN
    DECLARE v_daily_rate DECIMAL(10,2);
    DECLARE v_days INT;
    DECLARE v_total_charge DECIMAL(10,2);
    DECLARE v_vehicle_status VARCHAR(20);
    DECLARE v_customer_count INT;
    DECLARE v_vehicle_count INT;

    -- Check whether the customer exists.
    SELECT COUNT(*)
    INTO v_customer_count
    FROM Customer
    WHERE customer_id = p_customer_id;

    IF v_customer_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Customer does not exist.';
    END IF;

    -- Check whether the vehicle exists.
    SELECT COUNT(*)
    INTO v_vehicle_count
    FROM Vehicle
    WHERE vehicle_id = p_vehicle_id;

    IF v_vehicle_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Vehicle does not exist.';
    END IF;

    -- Get vehicle status and daily rental rate.
    SELECT status, daily_rate
    INTO v_vehicle_status, v_daily_rate
    FROM Vehicle
    WHERE vehicle_id = p_vehicle_id;

    -- Vehicle must be available.
    IF v_vehicle_status <> 'Available' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Vehicle is not available for rental.';
    END IF;

    -- Validate rental dates.
    IF p_return_date < p_rental_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Return date cannot be before rental date.';
    END IF;

    -- Calculate number of rental days.
    SET v_days = DATEDIFF(p_return_date, p_rental_date);

    -- Treat same-day rental as one rental day.
    IF v_days <= 0 THEN
        SET v_days = 1;
    END IF;

    -- Calculate total rental charge.
    SET v_total_charge = v_days * v_daily_rate;

    -- Insert the new rental.
    INSERT INTO Rental (
        customer_id,
        vehicle_id,
        rental_date,
        return_date,
        total_charge,
        status
    )
    VALUES (
        p_customer_id,
        p_vehicle_id,
        p_rental_date,
        p_return_date,
        v_total_charge,
        'Active'
    );

    -- Mark the vehicle as rented.
    UPDATE Vehicle
    SET status = 'Rented'
    WHERE vehicle_id = p_vehicle_id;
END //

DELIMITER ;


-- ============================================================
-- PROCEDURE TEST
-- IMPORTANT:
-- Vehicle 3 is initially Available.
-- Expected charge:
-- 3 days x 3000 = 9000
--
-- Screenshot 6:
-- Capture the CALL and verification results.
-- ============================================================

CALL sp_RegisterNewRental(
    3,
    3,
    '2026-09-22',
    '2026-09-25'
);


-- Verify newly inserted rental.
SELECT *
FROM Rental
WHERE customer_id = 3
AND vehicle_id = 3;


-- Verify vehicle status changed to Rented.
SELECT *
FROM Vehicle
WHERE vehicle_id = 3;


-- ============================================================
-- TASK 6: TRIGGER
-- ============================================================

-- Remove trigger if it already exists.
DROP TRIGGER IF EXISTS trg_AfterRentalComplete;

DELIMITER //

CREATE TRIGGER trg_AfterRentalComplete
AFTER UPDATE ON Rental
FOR EACH ROW
BEGIN
    IF NEW.status = 'Completed'
       AND OLD.status = 'Active' THEN

        UPDATE Vehicle
        SET status = 'Available'
        WHERE vehicle_id = NEW.vehicle_id;

    END IF;
END //

DELIMITER ;


-- ============================================================
-- TRIGGER TEST
-- Screenshot 7: Capture the verification results.
--
-- Rental 1 is initially Active and Vehicle 1 is Rented.
-- After completion:
-- Rental 1 -> Completed
-- Vehicle 1 -> Available
-- ============================================================

UPDATE Rental
SET status = 'Completed'
WHERE rental_id = 1;


-- Verify rental status.
SELECT *
FROM Rental
WHERE rental_id = 1;


-- Verify vehicle status changed to Available.
SELECT *
FROM Vehicle
WHERE vehicle_id = 1;


-- ============================================================
-- TASK 7: OPTIMIZATION
-- ============================================================

-- Create an index for customer rental-history searches.
-- Screenshot 8A: Capture SHOW INDEX output.
DROP INDEX IF EXISTS idx_rental_customer ON Rental;

CREATE INDEX idx_rental_customer
ON Rental(customer_id);


-- Verify the index.
SHOW INDEX FROM Rental;


-- Check the query execution plan.
-- Screenshot 8B: Capture EXPLAIN output.
EXPLAIN
SELECT *
FROM Rental
WHERE customer_id = 1;


-- ============================================================
-- FINAL VERIFICATION
-- ============================================================

-- Verify all tables.
SELECT * FROM Customer;
SELECT * FROM Vehicle;
SELECT * FROM Rental;
SELECT * FROM Payment;

-- Verify view.
SELECT * FROM vw_ConsolidatedRentalReport;

-- Verify procedure exists.
SHOW PROCEDURE STATUS
WHERE Db = 'carrentaldb';

-- Verify trigger exists.
SHOW TRIGGERS FROM CarRentalDB;

-- Verify optimization index.
SHOW INDEX FROM Rental;


-- ============================================================
-- END OF CAR RENTAL MANAGEMENT SYSTEM SQL SCRIPT
-- ============================================================
