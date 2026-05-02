

```markdown
# POS System Database - Lab Project

**Student:** Feeza Kulsoom (2024-SE-03)  
**Course:** Database Systems  
**University:** University of Azad Jammu & Kashmir, Muzaffarabad  

---

## Project Overview

This is a complete Point of Sale (POS) database system developed for Database Systems lab. It manages products, customers, orders, and includes automated loyalty points and stock management.

---

## Database Structure

| Table | Records | Purpose |
|-------|---------|---------|
| categories | 10 | Product categories |
| products | 10 | Product catalog |
| users | 10 | System users |
| roles | 3 | User roles (Admin/Salesman/Customer) |
| customers | 10 | Customer details & loyalty |
| orders | 11 | Order transactions |
| order_items | 24 | Individual order items |

---

## Key Features

- **Loyalty Points:** 1 point per Rs. 100 spent
- **Auto Discount:** 1% discount per 100 points (max 20%)
- **Stock Management:** Automatically updates when orders placed
- **Order Total:** Calculated automatically from items
- **Role-Based Access:** Admin, Salesman, Customer roles

---

## Business Rules

```
Points Earned = FLOOR(Amount Spent / 100)
Discount % = MIN(FLOOR(Loyalty Points / 100), 20)
Stock Change = Stock - Quantity (when ordered)
Stock Restore = Stock + Quantity (when cancelled)
```

---

## Triggers (9 Total)

| Trigger | Table | Purpose |
|---------|-------|---------|
| set_discount_percent_on_insert | customers | Calculate discount from points |
| update_loyalty_points_after_insert | orders | Add points after purchase |
| set_order_discount_before_update | orders | Update discount if total changes |
| auto_fetch_price_before_insert | order_items | Get current product price |
| reduce_stock_after_insert | order_items | Decrease stock on sale |
| restore_stock_after_delete | order_items | Restore stock if cancelled |
| update_order_total_after_insert | order_items | Recalculate order total |
| update_order_total_after_update | order_items | Update total on quantity change |
| update_order_total_after_delete | order_items | Recalculate after removal |

---

## Sample Queries

### Top 5 Customers by Spending
```sql
SELECT c.full_name, SUM(o.final_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 5;
```

### Low Stock Alert
```sql
SELECT product_name, stock_quantity
FROM products
WHERE stock_quantity < 20;
```

### Daily Sales Report
```sql
SELECT DATE(order_data) AS date, 
       COUNT(*) AS orders, 
       SUM(final_amount) AS revenue
FROM orders
GROUP BY DATE(order_data);
```

### Products Never Sold
```sql
SELECT p.product_name
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;
```

### Customer with Highest Loyalty Points
```sql
SELECT full_name, loyalty_points, discount_percent
FROM customers
ORDER BY loyalty_points DESC
LIMIT 1;
```

---

## Setup Instructions

1. Install XAMPP (v8.2.12 or higher)
2. Start Apache and MySQL from XAMPP Control Panel
3. Open phpMyAdmin: `http://localhost/phpmyadmin`
4. Create database: `pos_system`
5. Import `pos_system.sql` file
6. Database ready to use

---

## XAMPP Installation Steps

| Step | Action |
|------|--------|
| 1 | Download XAMPP from apachefriends.org |
| 2 | Run installer as administrator |
| 3 | Select components: Apache, MySQL, PHP, phpMyAdmin |
| 4 | Install to `C:\xampp` |
| 5 | Open XAMPP Control Panel |
| 6 | Start Apache (Port 80 or 8080) |
| 7 | Start MySQL (Port 3306) |
| 8 | Verify: `http://localhost` or `http://localhost:8080` |

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Port 80 busy | Use `http://localhost:8080` |
| MySQL won't start | Check if another MySQL service is running |
| Foreign key error | Create parent tables before child tables |
| Access denied | Run XAMPP as administrator |

---

## File Structure

```
pos_system.sql          # Complete database dump
README.md               # This file
```

---

## Author

**Feeza Kulsoom**  
Roll No: 2024-SE-03  
Reg Number: 2024-UMDB-004738  

**Instructor:** Engr. Muhammad Awais

---

## License

This project is for academic purposes only.
```

