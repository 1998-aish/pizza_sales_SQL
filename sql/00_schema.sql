-- =====================================================================
-- Pizza Sales Analysis — schema and data load (PostgreSQL)
-- Unzip data/pizza_sales.zip first, then run this file from the repo root:
--   psql -d pizza_sales -f sql/00_schema.sql
-- =====================================================================

DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS pizzas;
DROP TABLE IF EXISTS pizza_types;

CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(50) PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    category      VARCHAR(50)  NOT NULL,
    ingredients   TEXT
);

CREATE TABLE pizzas (
    pizza_id      VARCHAR(50) PRIMARY KEY,
    pizza_type_id VARCHAR(50) NOT NULL REFERENCES pizza_types (pizza_type_id),
    size          VARCHAR(5)  NOT NULL,
    price         NUMERIC(6, 2) NOT NULL
);

CREATE TABLE orders (
    order_id   INT PRIMARY KEY,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL
);

CREATE TABLE order_details (
    order_details_id INT PRIMARY KEY,
    order_id         INT NOT NULL REFERENCES orders (order_id),
    pizza_id         VARCHAR(50) NOT NULL REFERENCES pizzas (pizza_id),
    quantity         INT NOT NULL
);

-- pizza_types.csv is Latin-1 encoded
\copy pizza_types   FROM 'data/pizza_sales/pizza_types.csv'   WITH (FORMAT csv, HEADER true, ENCODING 'LATIN1');
\copy pizzas        FROM 'data/pizza_sales/pizzas.csv'        WITH (FORMAT csv, HEADER true);
\copy orders        FROM 'data/pizza_sales/orders.csv'        WITH (FORMAT csv, HEADER true);
\copy order_details FROM 'data/pizza_sales/order_details.csv' WITH (FORMAT csv, HEADER true);
