# Restaurant Sales and Delivery Intelligence Dashboard

## Project Overview

This project analyzes restaurant sales performance across dine-in and Deliveroo orders using Power BI, Power Query, PostgreSQL, and DAX.

The goal was to transform messy restaurant sales data into a clean, decision-focused dashboard that helps restaurant managers understand revenue performance, menu profitability, customer behavior, and delivery location trends.

---
## Live Dashboard
[View Interactive Dashboard Here](https://app.powerbi.com/view?r=eyJrIjoiN2ZjMzY4NmQtM2YyNy00M2E0LTg3YjQtN2FkMTEzNDA2YmFiIiwidCI6IjU2OWMyNDM5LThkNGEtNGE5Yi1hMzZkLWJkZDEwYWRiZmY5NyJ9&pageName=9b703a71ab714826a6a0)


## Business Problem

Restaurant managers need more than total sales figures. They need to understand what is driving revenue, where profit is coming from, which products customers buy most, and which delivery areas should receive more business attention.

This project answers key business questions:

- Which menu categories generate the most revenue?
- Which items are the most profitable?
- How much revenue comes from Deliveroo compared to dine-in?
- Which customer groups contribute most to revenue?
- Which delivery areas perform best?
- What actions can improve revenue, profitability, and customer retention?

---

## Tools Used

- Power BI
- Power Query
- DAX
- PostgreSQL
- Excel
- VS Code
- GitHub

---

## Dataset

The project uses a simulated restaurant dataset designed to mirror real-world restaurant operations.

Tables used:

| Table | Description |
|---|---|
| customers | Customer details and signup dates |
| orders | Order-level data including order date, order type, and customer |
| order_items | Item-level transaction data |
| menu | Menu items, categories, prices, and cost data |
| customer_locations | Deliveroo customer delivery areas |

---

## Data Cleaning & Preparation

Power Query was used to clean and transform the raw data before analysis.

Key cleaning steps:

- Standardized category names
- Replaced generic item names with realistic menu item names
- Fixed unrealistic menu pricing
- Created clean dine-in, Deliveroo, and cost price columns
- Removed unreliable raw revenue fields
- Rebuilt revenue and profit calculations using clean pricing logic
- Added Deliveroo customer location data
- Validated relationships between tables
- Created a date table for proper time-based analysis

---

## Data Model

The dashboard uses a star schema model.

Relationships:

- `customers[customer_id]` → `orders[customer_id]`
- `orders[order_id]` → `order_items[order_id]`
- `menu[menu_id]` → `order_items[menu_id]`
- `customer_locations[location_id]` → `orders[location_id]`

This structure allows accurate filtering across customers, orders, menu items, and delivery locations.

---

## Key DAX Measures

### Revenue

```DAX
Revenue =
SUMX(
    order_items,
    order_items[quantity] *
    IF(
        RELATED(orders[order_type]) = "Dine-in",
        RELATED(menu[clean_dine_in_price]),
        RELATED(menu[clean_deliveroo_price])
    )
)


Profit

Profit =
SUMX(
    order_items,
    order_items[quantity] *
    (
        IF(
            RELATED(orders[order_type]) = "Dine-in",
            RELATED(menu[clean_dine_in_price]),
            RELATED(menu[clean_deliveroo_price])
        )
        - RELATED(menu[clean_cost_price])
    )
)

Margin % = DIVIDE([Profit], [Revenue])
AOV = DIVIDE([Revenue], [Total Orders])
```

## SQL Analysis

PostgreSQL was used to validate business metrics and perform exploratory analysis.

Example SQL query:

```sql
SELECT
    m.category,
    SUM(oi.quantity) AS total_quantity,
    SUM(
        CASE
            WHEN o.order_type = 'Dine-in'
            THEN oi.quantity * m.clean_dine_in_price
            ELSE oi.quantity * m.clean_deliveroo_price
        END
    ) AS revenue
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN menu m
    ON oi.menu_id = m.menu_id
GROUP BY m.category
ORDER BY revenue DESC;

```

## Dashboard Pages
### 1. Executive Overview
![Executive Overview](/Images/executive.png)

This page provides a high-level summary of business performance.

Key metrics and visuals:

* Revenue
* Profit
* Margin %
* Average Order Value
* Total Orders
* Monthly Revenue Trend
* Revenue by Category
* Top Selling Items by Quantity

### 2. Menu Performance
![Menu Performance](/Images/menu-performance.png)

This page analyzes item and category performance.

Key visuals:

* Top Revenue-Generating Items
* Top 5 Most Profitable Items
* Category Performance: Revenue vs Profit
* Item Performance Matrix

### 3. Customer & Location Intelligence
![Customer & Location Intellegence](/Images/customer-location-intellegence.png)

This page focuses on Deliveroo customer behavior and delivery area performance.

Key visuals:

* Total Deliveroo Revenue
* Average Customer Spend
* Top Delivery Area
* Revenue by Customer Type
* Top Customers by Revenue
* Revenue by Area
* Area Performance Analysis

### 4. Business Insights & Recommendations
![Business Insights & Recommendation](/Images/business-insights.png)
This page summarizes the major findings and recommended business actions.

## Key Insights
- **Deliveroo dependency is both a strength and a risk.** At 62% of total revenue, Deliveroo is the dominant sales channel — but this level of reliance on a single third-party platform is a concentration risk. If Deliveroo raises its commission rate or reduces visibility for this outlet, revenue drops materially. Building a direct ordering channel (even a simple WhatsApp or website flow) is a strategic hedge worth evaluating.

- **Hot Sandwiches carry the business.** The category leads on both revenue and profit, driven primarily by the Beef Steak Sandwich and Spicy Chicken Sandwich. These two items likely account for a disproportionate share of total margin — which means stock-outs, quality inconsistency, or price changes on these items have outsized consequences. They should be treated as protected SKUs.

- **High-frequency, low-revenue add-ons (sauces, drinks, sides) are an untapped margin lever.** These items sell well but contribute little to revenue individually. Bundling them with the top two sandwich items at a small discount (e.g. "meal deal" pricing) could lift average order value without meaningful margin erosion, since the add-ons already carry low production cost.

- **New customers outspending returning customers signals a retention problem, not an acquisition win.** When new customers generate more revenue than returning ones, it typically means the business is working harder and spending more to replace customers who don't come back. The 57.5% margin gives enough room to fund a lightweight loyalty mechanism — even a simple repeat-order discount — before the acquisition cost compounds.
-  **Dubai Marina, Downtown Dubai, and Business Bay are the delivery core.** These three areas likely represent the majority of Deliveroo orders. Concentrating delivery promotions and targeted offers within a defined radius of these zones will yield higher ROI than broad marketing spend.

- **A 57.5% profit margin is strong but needs context.** This margin is healthy for F&B, but understanding whether it holds across all order types (dine-in vs. Deliveroo) matters — Deliveroo pricing is typically higher to absorb platform commission. If the blended margin masks a weaker dine-in margin, that's an operational signal worth surfacing.

---

## Recommendations
- **Reduce single-channel dependency before it becomes a crisis.** Prioritise building a direct ordering option — even a minimal one. A 5–10% shift of Deliveroo orders to a direct channel at lower commission would meaningfully improve net margin without requiring revenue growth.

- **Protect the top two SKUs operationally.** Beef Steak Sandwich and Spicy Chicken Sandwich should have dedicated stock buffers, quality checklists, and be the last items to be 86'd during busy periods. Revenue concentration in two items means operational failures hit the P&L directly.

- **Bundle add-ons into meal deals to lift AOV.** Test a "sandwich + drink + sauce" bundle at 5–10% below à la carte pricing. Given add-on purchase frequency is already high, this is a low-risk AOV lever with no new customer acquisition required.

- **Launch a simple returning-customer incentive.** A repeat-order discount (e.g. 10% off the 3rd order) or a stamp-card mechanic via Deliveroo promotions would directly address the new-vs-returning revenue imbalance. Track the cohort 30 and 60 days post-launch to measure retention lift.

- **Expand delivery marketing within the top three areas before targeting new zones.** Penetrating Dubai Marina, Downtown Dubai, and Business Bay more deeply is lower cost and lower risk than expanding delivery radius. Once those areas are saturated, use the data to identify the next highest-potential zone.

- **Run a monthly margin split report by order type.** If dine-in margin is materially lower than Deliveroo margin (after platform fees), that informs staffing, opening hours, and whether to push in-venue upselling or lean into delivery growth.

## Skills Demonstrated
* Data cleaning with Power Query
* Data modeling using star schema
* DAX measure creation
* PostgreSQL data loading and analysis
* KPI design
* Dashboard storytelling
* Customer analysis
* Delivery location analysis
* Profitability analysis
* GitHub project documentation

## Conclusion

This project demonstrates an end-to-end business intelligence workflow, from raw data cleaning to dashboard development and business recommendations.

The final dashboard helps restaurant decision-makers understand revenue drivers, product performance, customer behavior, and delivery area opportunities.
