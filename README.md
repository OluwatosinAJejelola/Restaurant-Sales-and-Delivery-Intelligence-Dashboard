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
* Total revenue reached AED2.35M.
* Profit reached AED1.35M with a margin of 57.54%.
* Deliveroo generated over 62% of total revenue.
* Hot Sandwiches were the highest-performing category by revenue and profit.
* Beef Steak Sandwich and Spicy Chicken Sandwich were the strongest individual items.
* Dubai Marina was the top-performing Deliveroo area.
* New customers generated more revenue than returning customers.
* Low-ticket add-ons such as sauces, drinks, and sides sold frequently but contributed lower revenue.

## Recommendations
* Increase delivery-focused promotions since Deliveroo is the strongest sales channel.
* Promote high-performing categories such as Hot Sandwiches and Cold Sandwiches.
* Use upselling strategies for drinks, sauces, and sides.
* Target strong delivery areas such as Dubai Marina, Downtown Dubai, and Business Bay.
* Improve returning customer revenue through loyalty rewards and repeat-order incentives.
* Monitor high-volume low-revenue items separately from premium revenue drivers.

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
