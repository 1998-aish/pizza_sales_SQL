--Calculate the percentage contribution of each pizza type to total revenue.

WITH revenue_per_type AS ( SELECT
    pt.name,
    SUM(od.quantity*p.price) AS revenue
FROM
    order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name),
total AS (
Select SUM(revenue) as total_revenue
from revenue_per_type
)
select 
rpt.name, rpt.revenue,
ROUND((rpt.revenue/t.total_revenue*100),2) as percentage
from revenue_per_type rpt, total t
order by rpt.revenue desc;

--Analyze the cumulative revenue generated over time.

WITH daily_revenue AS (
    SELECT
        o.order_date,
        SUM(od.quantity * p.price) AS revenue
    FROM
        orders o
        JOIN order_details od ON o.order_id = od.order_id
        JOIN pizzas p ON od.pizza_id = p.pizza_id
    GROUP BY o.order_date
)
SELECT
    order_date,
    revenue,
    SUM(revenue) OVER (ORDER BY order_date) AS cumulative_revenue
FROM daily_revenue
ORDER BY order_date;

--Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select * from pizzas;
select * from pizza_types;
select * from order_details;
select * from orders;

WITH revenue_per_type AS (
    SELECT
        pt.category,
        pt.name,
        SUM(od.quantity * p.price) AS revenue
    FROM
        order_details od
        JOIN pizzas p ON od.pizza_id = p.pizza_id
        JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category, pt.name
),
ranked AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rank
    FROM revenue_per_type
)
SELECT
    category,
    name,
    revenue
FROM ranked
WHERE rank <= 3
ORDER BY category, revenue DESC;
















