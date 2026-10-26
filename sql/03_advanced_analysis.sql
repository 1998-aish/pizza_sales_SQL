-- =====================================================================
-- 03 · Advanced analysis (CTEs and window functions)
-- =====================================================================

-- Q11. Percentage contribution of each pizza type to total revenue
WITH revenue_per_type AS (
    SELECT pt.name, SUM(od.quantity * p.price) AS revenue
    FROM order_details od
    JOIN pizzas p       ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.name
)
SELECT name,
       revenue,
       ROUND(revenue / SUM(revenue) OVER () * 100, 2) AS pct_of_revenue
FROM revenue_per_type
ORDER BY revenue DESC;

-- Q12. Revenue share by pizza category
SELECT pt.category,
       ROUND(SUM(od.quantity * p.price), 2) AS revenue,
       ROUND(SUM(od.quantity * p.price) * 100.0
             / SUM(SUM(od.quantity * p.price)) OVER (), 1) AS pct_of_revenue
FROM order_details od
JOIN pizzas p       ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY revenue DESC;

-- Q13. Cumulative revenue over time
WITH daily_revenue AS (
    SELECT o.order_date, SUM(od.quantity * p.price) AS revenue
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    JOIN pizzas p         ON od.pizza_id = p.pizza_id
    GROUP BY o.order_date
)
SELECT order_date,
       revenue,
       SUM(revenue) OVER (ORDER BY order_date) AS cumulative_revenue
FROM daily_revenue
ORDER BY order_date;

-- Q14. Top 3 pizza types by revenue within each category
WITH revenue_per_type AS (
    SELECT pt.category, pt.name, SUM(od.quantity * p.price) AS revenue
    FROM order_details od
    JOIN pizzas p       ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category, pt.name
),
ranked AS (
    SELECT *, RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS revenue_rank
    FROM revenue_per_type
)
SELECT category, name, revenue
FROM ranked
WHERE revenue_rank <= 3
ORDER BY category, revenue DESC;
