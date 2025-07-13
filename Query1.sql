-- Retrieve the total number of orders placed.

select count(order_id) as total_order from orders;

-- Calculate the total revenue generated from pizza sales.

SELECT
    SUM(od.quantity * p.price) AS total_revenue
FROM
    order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id;

--Identify the highest-priced pizza

SELECT *
FROM pizzas
ORDER BY price DESC
LIMIT 1;

--Identify the most common pizza size ordered

SELECT
    p.size,
    SUM(od.quantity) AS total_quantity
FROM
    order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY total_quantity DESC
LIMIT 1;

--List the top 5 most ordered pizza types along with their quantities

SELECT
    pt.name, 
    SUM(od.quantity) AS total_quantity
FROM
    order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
	JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity DESC
LIMIT 5;









