-- =====================================================================
-- 01 · Basic metrics
-- =====================================================================

-- Q1. Total number of orders placed
SELECT COUNT(order_id) AS total_orders
FROM orders;

-- Q2. Total revenue generated from pizza sales
SELECT ROUND(SUM(od.quantity * p.price), 2) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;

-- Q3. Highest-priced pizza
SELECT pt.name, p.size, p.price
FROM pizzas p
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- Q4. Most common pizza size ordered
SELECT p.size, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY total_quantity DESC;

-- Q5. Top 5 most ordered pizza types by quantity
SELECT pt.name, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p       ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity DESC
LIMIT 5;
