CREATE TABLE order_items (
    order_item_id        INT,
    order_id             INT,
    menu_id              INT,
    quantity             INT,
    unit_price           NUMERIC(10,2),
    total_price          NUMERIC(10,2),
    category             TEXT,
    clean_cost_price     NUMERIC(10,2),
    clean_dine_in_price  NUMERIC(10,2),
    clean_deliveroo_price NUMERIC(10,2)
);
CREATE TABLE customer_locations (
    location_id        TEXT,
    area_name          TEXT,
    zone_type          TEXT,
    avg_income_level   TEXT
);

CREATE TABLE menu (
    item_name              TEXT,
    menu_id                INT,
    category               TEXT,
    clean_cost_price       NUMERIC(10,2),
    clean_dine_in_price    NUMERIC(10,2),
    clean_deliveroo_price  NUMERIC(10,2),
    dine_in_price          NUMERIC(10,2),
    deliveroo_price        NUMERIC(10,2),
    cost_price             NUMERIC(10,2)
);

CREATE TABLE customers (
customer_id TEXT,
customer_type TEXT,
signup_date DATE
);

