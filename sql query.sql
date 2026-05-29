-- ============================================
-- REAL ECOMMERCE DATASET
-- customers: 1000 | products: 70
-- orders: 5000 | order_items: 12644
-- ============================================

CREATE DATABASE IF NOT EXISTS real_ecommerce;
USE real_ecommerce;

-- ============================================
-- SECTION 1 : DATA OVERVIEW (HEAD)
-- ============================================
SELECT * FROM customers LIMIT 10;
SELECT * FROM products LIMIT 10;
SELECT * FROM orders LIMIT 10;
SELECT * FROM order_items LIMIT 10;

-- ============================================
-- SECTION 2 : ROW COUNT (TABLE SIZE CHECK)
-- ============================================
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;

-- ============================================
-- SECTION 3 : NULL VALUE CHECK
-- ============================================
SELECT * FROM orders 
WHERE total_amount IS NULL 
OR status IS NULL 
OR city IS NULL
OR order_id IS NULL
OR customer_id IS NULL;

-- ============================================
-- SECTION 4 : OVERALL BUSINESS PERFORMANCE
-- ============================================
SELECT 
    COUNT(*)                    AS total_orders,
    COUNT(DISTINCT city) 		AS TOTAL_CITES,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(total_amount)           AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_order_value,
    MAX(total_amount)           AS biggest_order,
    MIN(total_amount)           AS smallest_order
FROM orders;

-- ============================================
-- SECTION 5 : PRODUCT CATEGORIES
-- ============================================
SELECT DISTINCT category FROM products;

-- ============================================
-- SECTION 6 : DATE RANGE CHECK
-- ============================================
SELECT MIN(order_date) AS START_DATE,
	   MAX(order_date) AS END_DATE
FROM orders;

-- ============================================
-- SECTION 7 : ORDER STATUS BREAKDOWN
-- ============================================
SELECT status, COUNT(*) AS Total
FROM orders
GROUP BY status
ORDER BY Total DESC;

-- ============================================
-- SECTION 8 : CITY WISE ORDERS & REVENUE
-- ============================================
SELECT city, COUNT(*) AS TOTAL_ORDERS, SUM(total_amount) AS TOTAL_REVENUE
FROM orders
GROUP BY city
ORDER BY TOTAL_REVENUE DESC;

-- ============================================
-- SECTION 9 : CATEGORY WISE PRODUCT ANALYSIS
-- ============================================
SELECT category,
	   COUNT(*) 			AS TOTAL_PRODUCTS,
       ROUND(AVG(price), 2) AS avg_price,
       MIN(price)           AS cheapest,
       MAX(price)           AS costliest
FROM products
GROUP BY category
ORDER BY avg_price DESC;

-- ============================================
-- SECTION 10 : TOP 10 BEST SELLING PRODUCTS
-- ============================================
SELECT p.product_id, p.product_name, 
       SUM(oi.quantity)              AS total_sold,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name, p.product_id
ORDER BY total_sold DESC
LIMIT 10;

-- ============================================
-- SECTION 11 : TOP 10 CUSTOMERS BY SPENDING
-- ============================================
SELECT c.customer_id, c.name, c.city,
       COUNT(o.order_id)             AS total_orders,
       ROUND(SUM(o.total_amount), 2) AS total_spent
FROM orders o
JOIN customers c 
ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name, c.city
ORDER BY total_spent DESC
LIMIT 10;

-- ============================================
-- SECTION 12 : TOP 10 CUSTOMERS BY ORDER COUNT
-- ============================================
SELECT c.customer_id, c.name,
	COUNT(o.order_id) AS TOTAL_ORDER
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY TOTAL_ORDER DESC
LIMIT 10;

-- ============================================
-- SECTION 13 : CANCELLED ORDERS KE CUSTOMERS
-- ============================================
SELECT DISTINCT c.customer_id, c.name, c.city
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'Cancelled';

-- ============================================
-- SECTION 14 : TOP 10 CUSTOMERS BY AVG ORDER
-- ============================================
SELECT c.name,
       ROUND(AVG(o.total_amount), 2) AS avg_order
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY avg_order DESC
LIMIT 10;

-- ============================================
-- SECTION 15 : MONTHLY REVENUE TREND
-- ============================================
SELECT 
    YEAR(order_date)  AS year,
    MONTH(order_date) AS month,
    COUNT(*)          AS total_orders,
    ROUND(SUM(total_amount), 2) AS monthly_revenue
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year, month;
 
-- ============================================
-- SECTION 16 : ORDER CATEGORY BREAKDOWN
-- ============================================
SELECT 
    CASE 
        WHEN total_amount >= 10000 THEN 'Premium'
        WHEN total_amount >= 5000  THEN 'High'
        WHEN total_amount >= 1000  THEN 'Medium'
        ELSE 'Low'
    END AS order_category,
    COUNT(*)                    AS total_orders,
    ROUND(SUM(total_amount), 2) AS revenue
FROM orders
GROUP BY order_category
ORDER BY revenue DESC;
 
-- ============================================
-- SECTION 17 : PRODUCTS JO KABHI BIKI HI NAHI
-- ============================================
SELECT p.product_name, p.category, p.price
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;