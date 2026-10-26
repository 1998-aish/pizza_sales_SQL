-- =====================================================================
-- 02 · Intermediate analysis
-- =====================================================================

-- Q6. Total quantity ordered per pizza category
SELECT pt.category, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p       ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_quantity DESC;

-- Q7. Distribution of orders by hour of the day
SELECT EXTRACT(HOUR FROM order_time) AS order_hour,
       COUNT(*)                      AS total_orders
FROM orders
GROUP BY order_hour
ORDER BY order_hour;

-- Q8. Orders by day of the week
SELECT TO_CHAR(order_date, 'Day') AS day_of_week,
       COUNT(*)                   AS total_orders
FROM orders
GROUP BY day_of_week
ORDER BY total_orders DESC;

-- Q9. Average number of pizzas ordered per day
WITH daily_orders AS (
    SELECT o.order_date, SUM(od.quantity) AS pizzas_per_day
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.order_date
)
SELECT ROUND(AVG(pizzas_per_day), 1) AS avg_pizzas_per_day
FROM daily_orders;

-- Q10. Top 3 pizza types by revenue
SELECT pt.name, SUM(od.quantity * p.price) AS revenue
FROM order_details od
JOIN pizzas p       ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;
