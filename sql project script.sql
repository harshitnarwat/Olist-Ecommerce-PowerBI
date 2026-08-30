show databases;
use olist_bi;

select * from category_translation;
select * from customers;
select * from geolocation;
select * from order_items;
select * from order_payments;
select * from order_reviews;
select * from orders;
select * from products;
select * from sellers;

SELECT 'Orders → Customers' AS relationship, COUNT(*) AS unmatched
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

SELECT 'Order Items → Orders', COUNT(*)
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT 'Order Items → Products', COUNT(*)
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL

UNION ALL

SELECT 'Order Items → Sellers', COUNT(*)
FROM order_items oi
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL

UNION ALL

SELECT 'Payments → Orders', COUNT(*)
FROM order_payments op
LEFT JOIN orders o
    ON op.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT 'Reviews → Orders', COUNT(*)
FROM order_reviews r
LEFT JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    ROUND(SUM(oi.price), 2) AS product_revenue,
    ROUND(AVG(oi.price), 2) AS avg_item_price
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id;
    
SELECT
    o.order_status,
    COUNT(*) AS orders_without_items
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL
GROUP BY o.order_status
ORDER BY orders_without_items DESC;

SELECT
    order_status,
    COUNT(*) AS order_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM orders), 2) AS percentage
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

SELECT
    COALESCE(ct.product_category_name_english, 'Unknown') AS category,
    ROUND(SUM(oi.price), 2) AS revenue,
    COUNT(DISTINCT oi.order_id) AS orders
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY category
ORDER BY revenue DESC;

SELECT
    COALESCE(ct.product_category_name_english, 'Unknown') AS category,
    ROUND(SUM(oi.price), 2) AS revenue,
    COUNT(DISTINCT oi.order_id) AS orders,
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT oi.order_id),
        2
    ) AS revenue_per_order
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY category
ORDER BY revenue_per_order DESC;

SELECT
    c.customer_state AS state,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT c.customer_id) AS customers,
    ROUND(SUM(oi.price), 2) AS revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC;

SELECT
    c.customer_state AS state,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(oi.price), 2) AS revenue,
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY avg_order_value DESC;

SELECT
    c.customer_id,
    c.customer_state AS state,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(oi.price), 2) AS total_spend,
    ROUND(SUM(oi.price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_state
ORDER BY total_spend DESC
LIMIT 20;

SELECT
    c.customer_unique_id,
    c.customer_state AS state,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(oi.price), 2) AS total_spend,
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id), 2
    ) AS avg_order_value
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id, c.customer_state
HAVING COUNT(DISTINCT o.order_id) >= 2
ORDER BY total_spend DESC
LIMIT 20;

SELECT
    COUNT(DISTINCT customer_unique_id) AS total_customers,
    COUNT(DISTINCT CASE
        WHEN order_count >= 2 THEN customer_unique_id
    END) AS repeat_customers,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN order_count >= 2 THEN customer_unique_id
        END) * 100.0
        / COUNT(DISTINCT customer_unique_id),
        2
    ) AS repeat_customer_rate
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id) t;
    
    SELECT
    op.payment_type,
    COUNT(DISTINCT op.order_id) AS orders,
    ROUND(SUM(op.payment_value), 2) AS total_payment,
    ROUND(AVG(op.payment_value), 2) AS avg_payment
FROM order_payments op
GROUP BY op.payment_type
ORDER BY total_payment DESC;

SELECT
    payment_installments,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(payment_value), 2) AS total_payment,
    ROUND(AVG(payment_value), 2) AS avg_payment
FROM order_payments
GROUP BY payment_installments
ORDER BY payment_installments;

SELECT
    COUNT(*) AS delivered_orders,
    ROUND(AVG(DATEDIFF(order_delivered_customer_date,
                       order_purchase_timestamp)), 2) AS avg_delivery_days,
    ROUND(AVG(DATEDIFF(order_estimated_delivery_date,
                       order_delivered_customer_date)), 2) AS avg_days_ahead
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;
  
  SELECT
    COUNT(*) AS delivered_orders,
    SUM(
	CASE
	WHEN order_delivered_customer_date > order_estimated_delivery_date
	THEN 1 ELSE 0
	END) AS late_orders,
    ROUND(SUM(
            CASE
                WHEN order_delivered_customer_date > order_estimated_delivery_date
                THEN 1 ELSE 0
            END) * 100.0 / COUNT(*),2) AS late_delivery_rate
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;
  
  SELECT
    c.customer_state AS state,
    COUNT(*) AS delivered_orders,
    SUM(
        CASE
            WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
            THEN 1 ELSE 0
        END
    ) AS late_orders,
    ROUND(
        SUM(
            CASE
                WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
                THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS late_delivery_rate
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY c.customer_state
HAVING COUNT(*) >= 100
ORDER BY late_delivery_rate DESC;

SELECT
    DATE_FORMAT(order_delivered_customer_date, '%Y-%m') AS month,
    COUNT(*) AS delivered_orders,
    SUM(
        CASE
            WHEN order_delivered_customer_date > order_estimated_delivery_date
            THEN 1 ELSE 0
        END
    ) AS late_orders,
    ROUND(
        SUM(
            CASE
                WHEN order_delivered_customer_date > order_estimated_delivery_date
                THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS late_delivery_rate
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
GROUP BY DATE_FORMAT(order_delivered_customer_date, '%Y-%m')
ORDER BY month;

SELECT
    oi.seller_id,
    COUNT(DISTINCT oi.order_id) AS orders,
    ROUND(SUM(oi.price), 2) AS revenue,
    ROUND(AVG(oi.price), 2) AS avg_item_price
FROM order_items oi
GROUP BY oi.seller_id
ORDER BY revenue DESC
LIMIT 20;

SELECT
    oi.seller_id,
    COUNT(DISTINCT oi.order_id) AS orders,
    ROUND(SUM(oi.price), 2) AS revenue,
    ROUND(AVG(oi.price), 2) AS avg_item_price
FROM order_items oi
GROUP BY oi.seller_id
HAVING COUNT(DISTINCT oi.order_id) >= 100
ORDER BY orders DESC
LIMIT 20;

SELECT
    oi.seller_id,
    COUNT(DISTINCT oi.order_id) AS orders,
    ROUND(SUM(oi.price), 2) AS revenue,
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT oi.order_id),
        2
    ) AS revenue_per_order
FROM order_items oi
GROUP BY oi.seller_id
HAVING COUNT(DISTINCT oi.order_id) >= 100
ORDER BY revenue_per_order DESC
LIMIT 20;

SELECT
    oi.seller_id,
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    SUM(
        CASE
            WHEN o.order_delivered_customer_date >
                 o.order_estimated_delivery_date
            THEN 1 ELSE 0
        END
    ) AS late_orders,
    ROUND(
        SUM(
            CASE
                WHEN o.order_delivered_customer_date >
                     o.order_estimated_delivery_date
                THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(DISTINCT o.order_id),
        2
    ) AS late_delivery_rate
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY oi.seller_id
HAVING COUNT(DISTINCT o.order_id) >= 100
ORDER BY late_delivery_rate DESC
LIMIT 20;

SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(payment_value), 2) AS total_payment,
    ROUND(
        SUM(payment_value) * 100.0 /
        (SELECT SUM(payment_value) FROM order_payments),
        2
    ) AS payment_share
FROM order_payments
GROUP BY payment_type
ORDER BY total_payment DESC;

SELECT
    ROUND(AVG(order_value), 2) AS avg_order_value,
    ROUND(MIN(order_value), 2) AS min_order_value,
    ROUND(MAX(order_value), 2) AS max_order_value
FROM (
    SELECT
        o.order_id,
        SUM(oi.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.order_id) t;

SELECT
    CASE
        WHEN order_value < 50 THEN 'Below 50'
        WHEN order_value < 100 THEN '50 - 99'
        WHEN order_value < 250 THEN '100 - 249'
        WHEN order_value < 500 THEN '250 - 499'
        WHEN order_value < 1000 THEN '500 - 999'
        ELSE '1000+'
    END AS order_value_range,
    COUNT(*) AS orders,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM (
        SELECT o.order_id
        FROM orders o
        JOIN order_items oi
            ON o.order_id = oi.order_id
        GROUP BY o.order_id
    ) x), 2) AS percentage
FROM (
    SELECT
        o.order_id,
        SUM(oi.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.order_id
) t
GROUP BY order_value_range
ORDER BY
    CASE order_value_range
        WHEN 'Below 50' THEN 1
        WHEN '50 - 99' THEN 2
        WHEN '100 - 249' THEN 3
        WHEN '250 - 499' THEN 4
        WHEN '500 - 999' THEN 5
        WHEN '1000+' THEN 6
    END;
    
    WITH order_values AS (
    SELECT
        o.order_id,
        SUM(oi.price) AS order_value
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY o.order_id
),
ranked AS (
    SELECT
        order_value,
        ROW_NUMBER() OVER (ORDER BY order_value) AS rn,
        COUNT(*) OVER () AS total_orders
    FROM order_values
)
SELECT
    ROUND(AVG(order_value), 2) AS median_order_value
FROM ranked
WHERE rn IN (
    FLOOR((total_orders + 1) / 2),
    CEIL((total_orders + 1) / 2)
);

SELECT
    CASE
        WHEN order_count = 1 THEN '1 order'
        WHEN order_count = 2 THEN '2 orders'
        WHEN order_count = 3 THEN '3 orders'
        WHEN order_count = 4 THEN '4 orders'
        ELSE '5+ orders'
    END AS order_frequency,
    COUNT(*) AS customers
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) t
GROUP BY order_frequency
ORDER BY
    CASE order_frequency
        WHEN '1 order' THEN 1
        WHEN '2 orders' THEN 2
        WHEN '3 orders' THEN 3
        WHEN '4 orders' THEN 4
        WHEN '5+ orders' THEN 5
    END;
    
    SELECT
    review_score,
    COUNT(*) AS reviews,
    ROUND(AVG(DATEDIFF(
        o.order_delivered_customer_date,
        o.order_purchase_timestamp
    )), 2) AS avg_delivery_days
FROM order_reviews r
JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
GROUP BY review_score
ORDER BY review_score;

SELECT
    r.review_score,
    COUNT(*) AS reviews,
    SUM(
        CASE
            WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS late_orders,
    ROUND(
        SUM(
            CASE
                WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS late_delivery_rate
FROM order_reviews r
JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY r.review_score
ORDER BY r.review_score;

select user();




