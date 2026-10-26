# 🍕 Pizza Sales Analysis — SQL

**A full year of transactions from a pizza restaurant (21,350 orders, $817.9K revenue), analyzed in PostgreSQL to find what drives revenue and when demand peaks.**

![SQL](https://img.shields.io/badge/SQL-PostgreSQL-336791?logo=postgresql&logoColor=white)
![Techniques](https://img.shields.io/badge/Techniques-Joins%20·%20CTEs%20·%20Window%20Functions-555)

---

## 📌 Key findings

| Metric | Value |
|---|---|
| Total orders (2015) | **21,350** |
| Total revenue | **$817,860** |
| Average order value | **$38.31** |
| Pizzas per order | **2.3** |
| Pizzas sold per day | **138.5** on average |

1. **Two daily rush windows.** Orders peak at lunch (12–1 PM, ~2,500 orders per hour-slot over the year) and again at dinner (5–7 PM). Mid-afternoon (2–3 PM) runs at roughly 60% of peak — the natural window for staff breaks, prep, or a happy-hour promotion.
2. **Friday is the busiest day; Sunday is the slowest.** Friday sees 35% more orders than Sunday (3,538 vs 2,624), so Sunday is the strongest candidate for a targeted promotion.
3. **Chicken pizzas earn the most per pizza.** The top 3 revenue earners are all chicken pizzas (Thai, Barbecue, California), even though the Chicken category sells the fewest units — higher prices make up the difference.
4. **Revenue is evenly spread across categories.** Classic (26.9%), Supreme (25.5%), Chicken (24.0%) and Veggie (23.7%) are all close, so the menu isn't dependent on any single category.
5. **XL and XXL sizes barely sell.** Large is the most popular size; XL and XXL together are just 1.2% of pizzas sold — a case for simplifying the size menu.
6. **Underperformers to review:** The Brie Carre, Green Garden and Spinach Supreme pizzas are the three lowest revenue earners (each under 2% of revenue).
7. **Demand is steady year-round.** Monthly revenue stays between $64K and $73K, with no strong seasonal swing.

---

## 🧩 Questions answered

| Level | Questions | File |
|---|---|---|
| Basic | Total orders, total revenue, highest-priced pizza, most common size, top 5 pizzas by quantity | [`01_basic_metrics.sql`](sql/01_basic_metrics.sql) |
| Intermediate | Quantity by category, orders by hour and weekday, average pizzas per day, top 3 by revenue | [`02_intermediate_analysis.sql`](sql/02_intermediate_analysis.sql) |
| Advanced | Revenue share by pizza and category, cumulative revenue over time, top 3 pizzas per category | [`03_advanced_analysis.sql`](sql/03_advanced_analysis.sql) |

SQL techniques used: multi-table joins, aggregation, CTEs, window functions (`SUM() OVER`, `RANK() OVER (PARTITION BY …)`), and date/time extraction.

---

## 🗂 Data model

Four related tables:

```
orders (order_id, order_date, order_time)
   └── order_details (order_details_id, order_id, pizza_id, quantity)
          └── pizzas (pizza_id, pizza_type_id, size, price)
                 └── pizza_types (pizza_type_id, name, category, ingredients)
```

---

## ▶️ How to run

```bash
git clone https://github.com/1998-aish/pizza_sales_SQL.git
cd pizza_sales_SQL
unzip data/pizza_sales.zip -d data/

createdb pizza_sales
psql -d pizza_sales -f sql/00_schema.sql          # creates tables and loads the CSVs
psql -d pizza_sales -f sql/01_basic_metrics.sql
psql -d pizza_sales -f sql/02_intermediate_analysis.sql
psql -d pizza_sales -f sql/03_advanced_analysis.sql
```

---

## 📁 Repository structure

```
pizza_sales_SQL/
├── data/
│   └── pizza_sales.zip              # raw CSVs
├── sql/
│   ├── 00_schema.sql                # schema + data load
│   ├── 01_basic_metrics.sql
│   ├── 02_intermediate_analysis.sql
│   └── 03_advanced_analysis.sql
├── presentation/
│   └── pizza_sales_presentation.pdf # slide summary of findings
└── README.md
```

---

## 👩‍💻 Author

**Aishwarya Srivastava** — M.S. Data Science & Analytics, Arizona State University
[LinkedIn](https://www.linkedin.com/in/aish-sv123) · [GitHub](https://github.com/1998-aish)
