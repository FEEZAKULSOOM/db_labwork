

## Objective

To create a University Database and practice all SQL key concepts including Primary Key, Foreign Key, Unique Key, Composite Key, Candidate Key, Alternate Key, Super Key, Natural Key, and Surrogate Key.

---

## Database Schema

### Tables Created

| Table | Description |
|-------|-------------|
| department | Stores department information |
| student | Stores student information |
| course | Stores course information |
| enrollment | Links students to courses (junction table) |

---

## Keys Implemented

| Key Type | Implementation |
|----------|----------------|
| **Primary Key** | `student_id`, `course_id`, `dept_code`, composite in enrollment |
| **Foreign Key** | `dept_code` in student/course, `student_id`/`course_id` in enrollment |
| **Unique Key** | `roll_number`, `cnic`, `email`, `course_code`, `dept_name` |
| **Composite Key** | `(student_id, course_id, semester, year)` in enrollment |
| **Candidate Key** | `roll_number` and `cnic` (both qualify as candidate) |
| **Alternate Key** | `roll_number` (since `student_id` is Primary Key) |
| **Super Key** | `(student_id)`, `(student_id, name)`, `(roll_number, email)` etc. |
| **Natural Key** | `roll_number`, `course_code`, `dept_code` |
| **Surrogate Key** | `student_id` (AUTO_INCREMENT), `course_id` (AUTO_INCREMENT) |

---

## Table Structures

### department
| Column | Type | Key |
|--------|------|-----|
| dept_code | VARCHAR(10) | PRIMARY KEY |
| dept_name | VARCHAR(50) | UNIQUE |
| location | VARCHAR(100) | - |
| budget | DECIMAL(10,2) | - |

### student
| Column | Type | Key |
|--------|------|-----|
| student_id | INT | PRIMARY KEY (Surrogate) |
| roll_number | VARCHAR(20) | UNIQUE (Natural/Alternate) |
| cnic | VARCHAR(15) | UNIQUE (Candidate) |
| name | VARCHAR(50) | - |
| email | VARCHAR(50) | UNIQUE |
| dept_code | VARCHAR(10) | FOREIGN KEY |
| admission_date | DATE | - |
| father_name | VARCHAR(60) | - |

### course
| Column | Type | Key |
|--------|------|-----|
| course_id | INT | PRIMARY KEY (Surrogate) |
| course_code | VARCHAR(10) | UNIQUE (Natural) |
| course_name | VARCHAR(50) | - |
| credits | INT | CHECK (1-6) |
| dept_code | VARCHAR(10) | FOREIGN KEY |

### enrollment
| Column | Type | Key |
|--------|------|-----|
| student_id | INT | COMPOSITE KEY / FOREIGN KEY |
| course_id | INT | COMPOSITE KEY / FOREIGN KEY |
| semester | VARCHAR(20) | COMPOSITE KEY |
| year | INT | COMPOSITE KEY |
| grade | CHAR(2) | - |
| enrollment_date | DATE | - |

---

## Sample Data

### Department Records
| dept_code | dept_name | location | budget |
|-----------|-----------|----------|--------|
| CS | Computer Science | Building A | 500,000 |
| SE | Software Engineering | Building A | 450,000 |
| BBA | Business Administration | Building B | 300,000 |
| ENG | English | Building C | 200,000 |

### Student Records
| student_id | roll_number | name | dept_code |
|------------|-------------|------|-----------|
| 1 | 2024-SE-01 | Ali Khan | CS |
| 2 | 2024-SE-02 | Sara Ahmed | CS |
| 3 | 2024-SE-03 | Feeza Kulsoom | SE |
| 4 | 2024-SE-04 | Omar Farooq | BBA |

### Course Records
| course_id | course_code | course_name | credits | dept_code |
|-----------|-------------|-------------|---------|-----------|
| 1 | CS101 | Database Systems | 3 | CS |
| 2 | CS102 | Programming Fundamentals | 4 | CS |
| 3 | SE201 | Software Engineering | 3 | SE |
| 4 | BBA101 | Marketing Principles | 3 | BBA |
| 5 | ENG101 | English Composition | 2 | ENG |

---

## SQL Commands Used

| Command | Purpose |
|---------|---------|
| CREATE DATABASE | Create university_db |
| CREATE TABLE | Create all 4 tables |
| PRIMARY KEY | Define primary keys |
| FOREIGN KEY | Define relationships |
| UNIQUE KEY | Enforce uniqueness |
| CHECK | Validate credit values |
| INSERT | Add sample data |
| ALTER TABLE | Add/modify columns |
| TRUNCATE | Clear table data |
| DROP | Remove tables |
| SELECT | Query data |
| UPDATE | Modify data |
| DELETE | Remove data |

---

## Sample Queries

### Show all students with their department names
```sql
SELECT s.name, d.dept_name
FROM student s
JOIN department d ON s.dept_code = d.dept_code;
```

### Show students enrolled in Database Systems
```sql
SELECT s.name, e.grade
FROM student s
JOIN enrollment e ON s.student_id = e.student_id
JOIN course c ON e.course_id = c.course_id
WHERE c.course_name = 'Database Systems';
```

### Count students per department
```sql
SELECT d.dept_name, COUNT(s.student_id) AS student_count
FROM department d
LEFT JOIN student s ON d.dept_code = s.dept_code
GROUP BY d.dept_code;
```

---

## ER Diagram

```
┌─────────────┐     ┌─────────────┐
│ department  │     │   student   │
│─────────────│     │─────────────│
│ dept_code PK│◄────│ dept_code FK│
│ dept_name   │     │ student_id  │
│ location    │     │ name        │
│ budget      │     └──────┬──────┘
└──────┬──────┘            │
       │                   │
       ▼                   ▼
┌─────────────┐     ┌─────────────┐
│   course    │     │ enrollment  │
│─────────────│     │─────────────│
│ course_id PK│     │ student_id  │
│ dept_code FK│────►│ course_id   │
│ course_name │     │ semester    │
│ credits     │     │ year        │
└─────────────┘     │ grade       │
                    └─────────────┘
```

---

## Setup Instructions

1. Open phpMyAdmin
2. Create database: `university_db`
3. Import `lab3.sql` file
4. Run verification queries

---

## Files Included

| File | Description |
|------|-------------|
| lab3.sql | Complete database dump with tables and data |
| README.md | This file |

---

## Author

**Feeza Kulsoom**  
Roll No: 2024-SE-03  
Reg Number: 2024-UMDB-004738  

**Instructor:** Engr. Muhammad Awais

---

