-- ============================================================
-- UNIVERSITY LAB DATABASE
-- Complete SQL Lab Tasks 1-8
-- DBMS: MySQL / MariaDB
-- ============================================================

-- ------------------------------------------------------------
-- DATABASE SETUP
-- ------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS UniversityLab;
USE UniversityLab;

-- ============================================================
-- TASK 1: CREATE TABLES WITH CONSTRAINTS
-- ============================================================

CREATE TABLE IF NOT EXISTS departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    age INT,
    dept_id INT,
    CONSTRAINT fk_student_department
        FOREIGN KEY (dept_id)
        REFERENCES departments(dept_id)
);

CREATE TABLE IF NOT EXISTS courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    dept_id INT,
    CONSTRAINT fk_course_department
        FOREIGN KEY (dept_id)
        REFERENCES departments(dept_id)
);

CREATE TABLE IF NOT EXISTS instructors (
    instructor_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    dept_id INT,
    CONSTRAINT fk_instructor_department
        FOREIGN KEY (dept_id)
        REFERENCES departments(dept_id)
);

CREATE TABLE IF NOT EXISTS enrollments (
    student_id INT,
    course_id INT,
    semester VARCHAR(50) NOT NULL,
    PRIMARY KEY (student_id, course_id),
    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (student_id)
        REFERENCES students(student_id),
    CONSTRAINT fk_enrollment_course
        FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
);

-- Verify tables
SHOW TABLES;

-- ============================================================
-- TASK 2: INSERT DATA AND USE SELECT
-- ============================================================

INSERT INTO departments (dept_id, dept_name)
VALUES
(1, 'CS'),
(2, 'EE');

INSERT INTO students (student_id, name, email, age, dept_id)
VALUES
(1, 'Ali', 'ali@gmail.com', 20, 1),
(2, 'Sara', 'sara@gmail.com', 21, 1),
(3, 'Ahmed', 'ahmed@gmail.com', 22, 2);

INSERT INTO courses (course_id, course_name, dept_id)
VALUES
(101, 'Database', 1),
(102, 'AI', 1),
(201, 'Circuits', 2);

INSERT INTO instructors (instructor_id, name, email, dept_id)
VALUES
(1, 'Dr. Khan', 'khan@gmail.com', 1),
(2, 'Dr. Ahmed', 'dr.ahmed@gmail.com', 2);

INSERT INTO enrollments (student_id, course_id, semester)
VALUES
(1, 101, 'Fall 2025'),
(1, 102, 'Fall 2025'),
(2, 101, 'Fall 2025');

-- SELECT queries
SELECT * FROM departments;
SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM instructors;
SELECT * FROM enrollments;

-- SELECT specific columns
SELECT student_id, name, email
FROM students;

-- WHERE condition
SELECT *
FROM students
WHERE age >= 21;

-- ============================================================
-- TASK 3: UPDATE A STUDENT'S NAME
-- ============================================================

UPDATE students
SET name = 'Sara Khan'
WHERE student_id = 2;

-- Verify update
SELECT *
FROM students
WHERE student_id = 2;

-- ============================================================
-- TASK 4: DELETE A STUDENT RECORD
-- ============================================================
-- Sara (student_id = 2) has an enrollment, so the child
-- record must be deleted before deleting the student.

DELETE FROM enrollments
WHERE student_id = 2;

DELETE FROM students
WHERE student_id = 2;

-- Verify deletion
SELECT * FROM students;
SELECT * FROM enrollments;

-- ============================================================
-- TASK 5: TRUNCATE AND DROP
-- ============================================================
-- IMPORTANT:
-- TRUNCATE on a parent table referenced by a foreign key
-- causes MariaDB/MySQL error #1701.
-- Therefore, the foreign key is temporarily removed,
-- the table is truncated, and the foreign key is recreated.
--
-- This section is placed LAST because TRUNCATE/DROP are
-- destructive operations.

-- -------------------------
-- 5A. TRUNCATE demonstration
-- -------------------------

-- Reinsert a temporary student so TRUNCATE can be demonstrated.
INSERT INTO students (student_id, name, email, age, dept_id)
VALUES (4, 'Temporary Student', 'temporary@gmail.com', 20, 1);

SELECT * FROM students;

-- Remove the foreign key that references students.
ALTER TABLE enrollments
DROP FOREIGN KEY fk_enrollment_student;

-- TRUNCATE the parent table.
TRUNCATE TABLE students;

-- Recreate the foreign key.
ALTER TABLE enrollments
ADD CONSTRAINT fk_enrollment_student
FOREIGN KEY (student_id)
REFERENCES students(student_id);

-- Verify that students is empty.
SELECT * FROM students;

-- Restore the original sample students after the demonstration.
INSERT INTO students (student_id, name, email, age, dept_id)
VALUES
(1, 'Ali', 'ali@gmail.com', 20, 1),
(3, 'Ahmed', 'ahmed@gmail.com', 22, 2);

-- Verify restored data.
SELECT * FROM students;

-- -------------------------
-- 5B. DROP demonstration
-- -------------------------
-- A separate temporary table is used so the main lab tables
-- remain available for verification.

CREATE TABLE drop_demo (
    id INT PRIMARY KEY,
    name VARCHAR(100)
);

INSERT INTO drop_demo (id, name)
VALUES (1, 'Test Record');

SELECT * FROM drop_demo;

DROP TABLE drop_demo;

-- Verify that drop_demo no longer exists.
SHOW TABLES;

-- ============================================================
-- TASK 6: ADD A NEW COLUMN USING ALTER TABLE
-- ============================================================

ALTER TABLE students
ADD phone VARCHAR(20);

-- Verify the new column.
DESCRIBE students;

-- Add sample phone numbers.
UPDATE students
SET phone = '03001234567'
WHERE student_id = 1;

UPDATE students
SET phone = '03009876543'
WHERE student_id = 3;

SELECT * FROM students;

-- ============================================================
-- TASK 7: PRACTICE JOINS BETWEEN STUDENTS AND COURSES
-- ============================================================

-- INNER JOIN
SELECT
    s.student_id,
    s.name AS student_name,
    c.course_id,
    c.course_name,
    e.semester
FROM students s
INNER JOIN enrollments e
    ON s.student_id = e.student_id
INNER JOIN courses c
    ON e.course_id = c.course_id;

-- LEFT JOIN
SELECT
    s.student_id,
    s.name AS student_name,
    c.course_name
FROM students s
LEFT JOIN enrollments e
    ON s.student_id = e.student_id
LEFT JOIN courses c
    ON e.course_id = c.course_id;

-- RIGHT JOIN
SELECT
    s.student_id,
    s.name AS student_name,
    c.course_name
FROM students s
RIGHT JOIN enrollments e
    ON s.student_id = e.student_id
RIGHT JOIN courses c
    ON e.course_id = c.course_id;

-- ============================================================
-- TASK 8: CANDIDATE KEYS, ALTERNATE KEYS,
--         AND COMPOSITE KEYS
-- ============================================================

-- Candidate Key:
-- A candidate key is a column (or set of columns) that can
-- uniquely identify a record.
--
-- In students:
-- student_id is a candidate key.
-- email is also a candidate key because it is UNIQUE.
--
-- Primary Key:
-- student_id is selected as the primary key.
--
-- Alternate Key:
-- email is a candidate key that is not selected as the
-- primary key, so it acts as an alternate key.
--
-- Composite Key:
-- enrollments uses (student_id, course_id) as a composite
-- primary key.

-- View the student keys.
SELECT
    student_id,
    email
FROM students;

-- View the enrollment composite key.
SELECT
    student_id,
    course_id,
    semester
FROM enrollments;

-- ============================================================
-- ADDITIONAL KEY EXAMPLE
-- ============================================================

CREATE TABLE IF NOT EXISTS citizens (
    cnic VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE
);

-- CNIC is the primary/natural key.
-- Email is an alternate key because it is UNIQUE.

INSERT INTO citizens (cnic, name, email)
VALUES
('37405-1234567-1', 'Usman', 'usman@gmail.com'),
('37405-7654321-2', 'Hina', 'hina@gmail.com');

SELECT * FROM citizens;

-- ============================================================
-- SURROGATE KEY EXAMPLE
-- ============================================================

CREATE TABLE IF NOT EXISTS employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE
);

INSERT INTO employees (employee_name, email)
VALUES
('John', 'john@gmail.com'),
('Mary', 'mary@gmail.com');

SELECT * FROM employees;

-- employee_id is a surrogate/artificial key.
-- email is an alternate key.

-- ============================================================
-- ADDITIONAL ALTER TABLE PRACTICE
-- ============================================================

-- ADD COLUMN
ALTER TABLE employees
ADD department VARCHAR(100);

-- MODIFY COLUMN
ALTER TABLE employees
MODIFY department VARCHAR(150);

-- CHANGE COLUMN NAME
ALTER TABLE employees
CHANGE department department_name VARCHAR(150);

-- DROP COLUMN
ALTER TABLE employees
DROP COLUMN department_name;

-- Verify final employee structure.
DESCRIBE employees;

-- ============================================================
-- FINAL VERIFICATION
-- ============================================================

SELECT * FROM departments;
SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM instructors;
SELECT * FROM enrollments;
SELECT * FROM citizens;
SELECT * FROM employees;

-- ============================================================
-- END OF UNIVERSITY LAB SQL SCRIPT
-- ============================================================
