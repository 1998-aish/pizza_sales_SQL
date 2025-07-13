-- Determine the distribution of orders by hour of the day.

SELECT
    EXTRACT(HOUR FROM order_time) AS hour,
    COUNT(*) AS total_orders
FROM orders
GROUP BY hour
ORDER BY hour;

--Do relevant joins to find the category-wise distribution of pizzas.

SELECT
    pt.category,
    SUM(od.quantity) AS total_quantity
FROM
    order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_quantity DESC;

--Group the orders by date and calculate the average number of pizzas ordered per day.

WITH daily_orders AS (
    SELECT
        o.order_date,
        SUM(od.quantity) AS pizzas_per_day
    FROM
        orders o
        JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.order_date
)
SELECT
    AVG(pizzas_per_day) AS avg_pizzas_per_day
FROM daily_orders;


--Determine the top 3 most ordered pizza types based on revenue.

SELECT
    pt.name,
    SUM(od.quantity*p.price) AS revenue
FROM
    order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;















