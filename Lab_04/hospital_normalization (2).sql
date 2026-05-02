-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 02, 2026 at 01:49 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- ====================================================
-- STUDENT: Feeza Kulsoom
-- ROLL NO: 2024-SE-03
-- REG NO: 2024-UMDB-004738
-- LAB: Hospital Normalization (Assessment Problem)
-- DATE: May 2026
-- ====================================================

-- ====================================================
-- TASK 1: FUNCTIONAL DEPENDENCIES & CANDIDATE KEY
-- ====================================================

-- FUNCTIONAL DEPENDENCIES:
-- ========================
-- FD1: VisitID → VisitDate, PatientID, PatientName, PatientPhone, 
--      DoctorID, DoctorName, Specialty, DeptName, DeptHead, Diagnosis, Fee
--
-- FD2: PatientID → PatientName, PatientPhone
--
-- FD3: DoctorID → DoctorName, Specialty, DeptName, DeptHead
--
-- FD4: DeptName → DeptHead
--
-- CANDIDATE KEY:
-- =============
-- VisitID is the candidate key because it uniquely identifies each row in the table.

-- ====================================================
-- TASK 2: 1NF (First Normal Form)
-- ====================================================
-- The table is already in 1NF because all values are atomic and there are no repeating groups.
-- Primary Key: VisitID

--
-- Database: `hospital_normalization`
--

CREATE DATABASE IF NOT EXISTS `hospital_normalization`;
USE `hospital_normalization`;

-- --------------------------------------------------------

--
-- Table structure for table `hospital_1nf`
--

CREATE TABLE `hospital_1nf` (
  `VisitID` varchar(10) NOT NULL,
  `VisitDate` date DEFAULT NULL,
  `PatientID` varchar(10) DEFAULT NULL,
  `PatientName` varchar(50) DEFAULT NULL,
  `PatientPhone` varchar(20) DEFAULT NULL,
  `DoctorID` varchar(10) DEFAULT NULL,
  `DoctorName` varchar(50) DEFAULT NULL,
  `Specialty` varchar(50) DEFAULT NULL,
  `DeptName` varchar(50) DEFAULT NULL,
  `DeptHead` varchar(50) DEFAULT NULL,
  `Diagnosis` varchar(100) DEFAULT NULL,
  `Fee` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hospital_1nf`
--

INSERT INTO `hospital_1nf` (`VisitID`, `VisitDate`, `PatientID`, `PatientName`, `PatientPhone`, `DoctorID`, `DoctorName`, `Specialty`, `DeptName`, `DeptHead`, `Diagnosis`, `Fee`) VALUES
('V-9001', '2026-04-10', 'P-201', 'Hassan', '0300-1112233', 'D-30', 'Dr. Imran', 'Cardiology', 'Heart Care', 'Dr. Tariq', 'Hypertension', 2500.00),
('V-9002', '2026-04-10', 'P-202', 'Mehreen', '0301-4445566', 'D-31', 'Dr. Asma', 'Dermatology', 'Skin Clinic', 'Dr. Asma', 'Eczema', 2000.00),
('V-9003', '2026-04-11', 'P-201', 'Hassan', '0300-1112233', 'D-31', 'Dr. Asma', 'Dermatology', 'Skin Clinic', 'Dr. Asma', 'Allergy', 2000.00),
('V-9004', '2026-04-12', 'P-203', 'Junaid', '0302-7778899', 'D-30', 'Dr. Imran', 'Cardiology', 'Heart Care', 'Dr. Tariq', 'Arrhythmia', 3000.00);

-- ====================================================
-- TASK 3: 2NF (Second Normal Form)
-- ====================================================

-- 2NF DEFINITION:
-- A table is in 2NF if:
-- 1. It is in 1NF
-- 2. There are NO partial dependencies (no non-key attribute depends on only PART of a composite key)

-- ANALYSIS OF OUR 1NF TABLE:
-- ==========================
-- Primary key: VisitID (SINGLE column, NOT composite)
-- 
-- Partial dependency check: 
-- A partial dependency requires a composite primary key (e.g., (VisitID, ProductID)).
-- Since our primary key has only ONE column, partial dependencies are IMPOSSIBLE by definition.
--
-- CONCLUSION: The 1NF table automatically satisfies 2NF requirements.
-- Therefore, the 2NF schema is IDENTICAL to the 1NF schema.

-- PARTIAL DEPENDENCIES REMOVED: NONE (there were no partial dependencies to begin with)

-- 2NF TABLE (same as 1NF):
CREATE TABLE `hospital_2nf` LIKE `hospital_1nf`;
INSERT INTO `hospital_2nf` SELECT * FROM `hospital_1nf`;

-- JUSTIFICATION:
-- ==============
-- No partial dependencies existed because:
-- 1. The primary key (VisitID) is a single column
-- 2. Partial dependencies can only occur with composite primary keys
-- 3. All non-key attributes are fully functionally dependent on the entire primary key
--
-- Note: Transitive dependencies still exist in this 2NF table:
-- - VisitID → PatientID → PatientName, PatientPhone
-- - VisitID → DoctorID → DoctorName, Specialty, DeptName
-- - DeptName → DeptHead
-- These will be addressed in 3NF (Task 4).

-- ====================================================
-- TASK 4: 3NF (Third Normal Form)
-- ====================================================

-- 3NF DEFINITION:
-- A table is in 3NF if:
-- 1. It is in 2NF
-- 2. There are NO transitive dependencies (no non-key attribute depends on another non-key attribute)

-- TRANSITIVE DEPENDENCIES IDENTIFIED IN 2NF TABLE:
-- ================================================
-- 1. VisitID → PatientID → PatientName, PatientPhone
-- 2. VisitID → DoctorID → DoctorName, Specialty, DeptName
-- 3. DeptName → DeptHead (within Doctor dependency chain)
--
-- SOLUTION: Decompose into 4 tables to remove all transitive dependencies
-- ====================================================

-- --------------------------------------------------------

--
-- Table 1: patients (removes transitive dependency PatientID → PatientName, PatientPhone)
--

CREATE TABLE `patients` (
  `PatientID` varchar(10) NOT NULL,
  `PatientName` varchar(50) NOT NULL,
  `PatientPhone` varchar(20) NOT NULL,
  PRIMARY KEY (`PatientID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`PatientID`, `PatientName`, `PatientPhone`) VALUES
('P-201', 'Hassan', '0300-1112233'),
('P-202', 'Mehreen', '0301-4445566'),
('P-203', 'Junaid', '0302-7778899');

-- --------------------------------------------------------

--
-- Table 2: departments (removes transitive dependency DeptName → DeptHead)
--

CREATE TABLE `departments` (
  `DeptName` varchar(50) NOT NULL,
  `DeptHead` varchar(50) NOT NULL,
  PRIMARY KEY (`DeptName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`DeptName`, `DeptHead`) VALUES
('Heart Care', 'Dr. Tariq'),
('Skin Clinic', 'Dr. Asma');

-- --------------------------------------------------------

--
-- Table 3: doctors (removes transitive dependency DoctorID → DoctorName, Specialty, DeptName)
-- Note: DeptName is a foreign key to departments table
--

CREATE TABLE `doctors` (
  `DoctorID` varchar(10) NOT NULL,
  `DoctorName` varchar(50) NOT NULL,
  `Specialty` varchar(50) NOT NULL,
  `DeptName` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`DoctorID`),
  FOREIGN KEY (`DeptName`) REFERENCES `departments` (`DeptName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctors`
--

INSERT INTO `doctors` (`DoctorID`, `DoctorName`, `Specialty`, `DeptName`) VALUES
('D-30', 'Dr. Imran', 'Cardiology', 'Heart Care'),
('D-31', 'Dr. Asma', 'Dermatology', 'Skin Clinic');

-- --------------------------------------------------------

--
-- Table 4: visits (main transaction table with foreign keys)
--

CREATE TABLE `visits` (
  `VisitID` varchar(10) NOT NULL,
  `VisitDate` date NOT NULL,
  `PatientID` varchar(10) DEFAULT NULL,
  `DoctorID` varchar(10) DEFAULT NULL,
  `Diagnosis` varchar(100) DEFAULT NULL,
  `Fee` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`VisitID`),
  FOREIGN KEY (`PatientID`) REFERENCES `patients` (`PatientID`),
  FOREIGN KEY (`DoctorID`) REFERENCES `doctors` (`DoctorID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `visits`
--

INSERT INTO `visits` (`VisitID`, `VisitDate`, `PatientID`, `DoctorID`, `Diagnosis`, `Fee`) VALUES
('V-9001', '2026-04-10', 'P-201', 'D-30', 'Hypertension', 2500.00),
('V-9002', '2026-04-10', 'P-202', 'D-31', 'Eczema', 2000.00),
('V-9003', '2026-04-11', 'P-201', 'D-31', 'Allergy', 2000.00),
('V-9004', '2026-04-12', 'P-203', 'D-30', 'Arrhythmia', 3000.00);

-- ====================================================
-- TASK 5: SELECT QUERY TO RECREATE ORIGINAL TABLE 8.1
-- ====================================================
-- This query joins all 4 tables to reproduce the original unnormalized data
-- ====================================================

SELECT 
    v.VisitID,
    v.VisitDate,
    p.PatientID,
    p.PatientName,
    p.PatientPhone,
    d.DoctorID,
    d.DoctorName,
    d.Specialty,
    dept.DeptName,
    dept.DeptHead,
    v.Diagnosis,
    v.Fee
FROM visits v
JOIN patients p ON v.PatientID = p.PatientID
JOIN doctors d ON v.DoctorID = d.DoctorID
JOIN departments dept ON d.DeptName = dept.DeptName
ORDER BY v.VisitID;

-- ====================================================
-- TASK 6: ANOMALIES ELIMINATED BY 3NF DESIGN
-- ====================================================

-- INSERTION ANOMALY ELIMINATED:
-- =============================
-- BEFORE (2NF): Could not add a new patient without a visit record.
-- Example: To add patient 'P-999', 'Ali', '0300-1234567' in 2NF, you would need
-- to create a dummy visit record with NULL values.
--
-- AFTER (3NF): Can add patient independently:
-- INSERT INTO patients VALUES ('P-999', 'Ali', '0300-1234567');
-- No visit record required.
-- 
-- BEFORE: Could not add a new department without a doctor assigned.
-- AFTER (3NF): Can add department directly:
-- INSERT INTO departments VALUES ('Neurology', 'Dr. Brain');
-- 
-- BEFORE: Could not add a new doctor without a visit record.
-- AFTER (3NF): Can add doctor independently:
-- INSERT INTO doctors VALUES ('D-32', 'Dr. Zara', 'Neurology', 'Neurology');

-- UPDATE ANOMALY ELIMINATED:
-- ==========================
-- BEFORE: Changing Dr. Asma's department head would require updating multiple rows.
-- Example: If DeptHead changed from 'Dr. Asma' to 'Dr. New', all dermatology rows
-- would need updating in 2NF table (2 rows in this case).
--
-- AFTER: Department head stored once in departments table:
-- UPDATE departments SET DeptHead = 'Dr. New' WHERE DeptName = 'Skin Clinic';
-- Single row update only.
--
-- BEFORE: Changing patient phone number required updating all visits by that patient.
-- AFTER: Update once in patients table.

-- DELETION ANOMALY ELIMINATED:
-- ============================
-- BEFORE: Deleting V-9004 would delete patient Junaid and Dr. Imran's info.
-- Example: DELETE FROM hospital_2nf WHERE VisitID = 'V-9004';
-- This would remove Junaid and Dr. Imran completely from the system.
--
-- AFTER: Deleting visit only removes the consultation record:
-- DELETE FROM visits WHERE VisitID = 'V-9004';
-- Patient 'Junaid' remains in patients table.
-- Doctor 'Dr. Imran' remains in doctors table.
-- Department 'Heart Care' remains in departments table.
--
-- BEFORE: Deleting last dermatology visit would delete Skin Clinic department.
-- AFTER: Department exists independently regardless of visit records.

-- ====================================================
-- SUMMARY
-- ====================================================
-- Original Table: 1 table with 12 columns, 4 rows
-- 1NF: 1 table (hospital_1nf) - all atomic values, no repeating groups
-- 2NF: 1 table (hospital_2nf) - same as 1NF because no partial dependencies exist
-- 3NF: 4 tables (patients, departments, doctors, visits)
-- Foreign Keys: 3 (doctors → departments, visits → patients, visits → doctors)
-- Total anomalies eliminated: Insertion (3 types), Update (2 types), Deletion (2 types)
-- Normalization Level Achieved: 3NF
-- ====================================================

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;