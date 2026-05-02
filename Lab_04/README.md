
# Database Normalization Lab - Lab #04


## Objective

To convert unnormalized bookstore order data into 1NF, 2NF, and 3NF by identifying and removing functional dependencies, partial dependencies, and transitive dependencies.

---

## Tasks Completed

| Task | Description |
|------|-------------|
| Task 1 | Identified 4 Functional Dependencies and 3 anomalies (Insertion, Update, Deletion) |
| Task 2 | Converted to 1NF with composite primary key (OrderID, BookID) |
| Task 3 | Converted to 2NF with 3 tables (Orders, Books, OrderDetails) |
| Task 4 | Converted to 3NF with 4 tables (Customers, Orders, Books, OrderDetails) |
| Task 5 | Created verification queries to reproduce original report and customer spending |
| Task 6 | Written reflection on how 3NF prevents all anomalies |

---

## Files Included

| File | Description |
|------|-------------|
| `normalization.pdf` | Complete lab report with screenshots |
| `normalization.sql` | All SQL code for 1NF, 2NF, 3NF tables and queries |

---

## Database Schema (3NF Final)

```
Customers (CustID PK, CustName, CustEmail)
    ↑
Orders (OrderID PK, OrderDate, CustID FK)
    ↑
OrderDetails (OrderID FK, BookID FK, Qty) → Composite PK
    ↑
Books (BookID PK, BookTitle, Publisher, UnitPrice)
```

---

## Sample Query

```sql
-- Customer total spend
SELECT c.CustName, SUM(od.Qty * b.UnitPrice) AS TotalSpend
FROM Customers_3NF c
JOIN Orders_3NF o ON c.CustID = o.CustID
JOIN OrderDetails_3NF od ON o.OrderID = od.OrderID
JOIN Books_3NF b ON od.BookID = b.BookID
GROUP BY c.CustID;
```

---

## Results

| Customer | Total Spend |
|----------|-------------|
| Bilal | 7500 |
| Areeba | 3600 |

---



---

This README is **short, professional, and covers everything** for your lab! ✅
