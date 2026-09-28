# Car Rental Management System

Database Systems (Open Ended Lab) project

**Author:** Feeza Kulsoom (Roll No: `2024-SE-03`, Reg No: `2024-UMDB-004738`)  
**Instructor:** Engr. Muhammad Awais  

---

## 📌 R Contents

This folder contains the complete database design, relational implementation, and SQL scripts for the **Car Rental Management System**:

* **`schema.sql`** — Complete MySQL script including table creation, integrity constraints, and sample data.
* **`queries.sql`** — Multi-table `JOIN` queries for relational data retrieval and reporting.
* **`views.sql`** — `vw_ConsolidatedRentalReport` for unified business auditing.
* **`procedures.sql`** — Stored procedure `sp_RegisterNewRental` for automated booking and duration/cost calculation.
* **`triggers.sql`** — Automated trigger `trg_AfterRentalComplete` to mark vehicles as `Available` upon rental completion.
* **`optimization.sql`** — B-Tree indexing (`idx_rental_customer`) and `EXPLAIN` query execution analysis.
* **`docs/`** — Normalization breakdown (1NF to 3NF) and entity-relationship specifications.

---


