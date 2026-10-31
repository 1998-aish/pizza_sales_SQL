"""Generate README charts from data/pizza_sales.zip.  Run: python src/make_charts.py"""
import zipfile
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "images"
OUT.mkdir(exist_ok=True)

with zipfile.ZipFile(ROOT / "data" / "pizza_sales.zip") as z:
    read = lambda n, **k: pd.read_csv(z.open(f"pizza_sales/{n}.csv"), **k)
    orders, details = read("orders"), read("order_details")
    pizzas, types = read("pizzas"), read("pizza_types", encoding="latin1")

df = details.merge(pizzas, on="pizza_id").merge(types, on="pizza_type_id").merge(orders, on="order_id")
df["revenue"] = df["quantity"] * df["price"]
orders["hour"] = pd.to_datetime(orders["time"], format="%H:%M:%S").dt.hour
orders["weekday"] = pd.to_datetime(orders["date"]).dt.day_name()

plt.rcParams.update({"figure.dpi": 120, "axes.spines.top": False, "axes.spines.right": False,
                     "axes.titleweight": "bold"})
RED, GREY = "#C0392B", "#C9C9C9"

fig, axes = plt.subplots(1, 3, figsize=(15, 4.2), gridspec_kw={"width_ratios": [1.4, 1, 1]})

by_hour = orders[orders["hour"].between(11, 23)].groupby("hour").size()
axes[0].bar(by_hour.index, by_hour.values,
            color=[RED if h in (12, 13, 17, 18) else GREY for h in by_hour.index])
axes[0].set_title("Orders by hour: lunch & dinner rush")
axes[0].set_xticks(by_hour.index, [f"{h % 12 or 12}{'a' if h < 12 else 'p'}" for h in by_hour.index])
axes[0].set_ylabel("Orders (2015)")

days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
by_day = orders.groupby("weekday").size().reindex(days)
axes[1].bar([d[:3] for d in days], by_day.values,
            color=[RED if d == "Friday" else GREY for d in days])
axes[1].set_title("Orders by weekday: Friday peaks")

cat = df.groupby("category")["revenue"].sum().sort_values()
axes[2].barh(cat.index, cat.values / 1000, color=GREY)
for i, v in enumerate(cat.values / 1000):
    axes[2].text(v + 3, i, f"${v:.0f}K ({v * 1000 / cat.sum():.0%})", va="center", fontsize=9)
axes[2].set_xlim(0, 280)
axes[2].set_title("Revenue by category: evenly split")

fig.suptitle(f"Pizza sales 2015 · {orders['order_id'].nunique():,} orders · ${df['revenue'].sum():,.0f} revenue",
             fontweight="bold", fontsize=13)
fig.tight_layout()
fig.savefig(OUT / "sales_overview.png")
print("saved", OUT / "sales_overview.png")
