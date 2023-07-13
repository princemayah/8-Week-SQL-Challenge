-- 1. What is the total amount each customer spent at the restaurant?

SELECT
    s.customer_id,
    SUM(m.price) AS total_spent
FROM dannys_diner.sales AS s
INNER JOIN dannys_diner.menu AS m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;

-- 2. How many days has each customer visited the restaurant?

SELECT
    customer_id,
    COUNT(DISTINCT order_date) AS visits
FROM dannys_diner.sales
GROUP BY customer_id;

-- 3. What was the first item from the menu purchased by each customer?

WITH ranking AS (
    SELECT
        customer_id,
        order_date,
        product_id,
        DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY order_date) AS date_rank
    FROM dannys_diner.sales
)

SELECT
    r.customer_id,
    m.product_name
FROM ranking AS r
INNER JOIN dannys_diner.menu AS m ON r.product_id = m.product_id
WHERE r.date_rank = 1
GROUP BY r.customer_id, r.order_date, m.product_name;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT
    m.product_name,
    COUNT(s.product_id) AS sales_count
FROM dannys_diner.sales AS s
INNER JOIN dannys_diner.menu AS m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY sales_count DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?

WITH popular AS (
    SELECT
        s.customer_id,
        m.product_name,
        COUNT(m.product_id) AS product_count,
        DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY COUNT(s.customer_id) DESC) AS rank
    FROM dannys_diner.sales AS s
    INNER JOIN dannys_diner.menu AS m ON s.product_id = m.product_id
    GROUP BY s.customer_id, m.product_name
)

SELECT
    customer_id,
    product_name,
    product_count
FROM popular
WHERE rank = 1;

-- 6. Which item was purchased first by the customer after they became a member?

WITH after_membership AS (
    SELECT
        s.customer_id, 
        s.product_id,
        ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date ASC) AS row_num
    FROM dannys_diner.sales AS s
    INNER JOIN dannys_diner.members AS m ON s.customer_id = m.customer_id
        AND s.order_date > m.join_date
)

SELECT 
    a.customer_id, 
    m.product_name
FROM after_membership AS a
INNER JOIN dannys_diner.menu AS m ON a.product_id = m.product_id
WHERE row_num = 1
ORDER BY customer_id ASC;

-- 7. Which item was purchased just before the customer became a member?

WITH before_membership AS (
    SELECT
        s.customer_id, 
        s.product_id,
        ROW_NUMBER() OVER(PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS row_num
    FROM dannys_diner.sales AS s
    INNER JOIN dannys_diner.members AS m ON s.customer_id = m.customer_id
        AND s.order_date < m.join_date
)

SELECT 
    a.customer_id, 
    m.product_name
FROM before_membership AS a
INNER JOIN dannys_diner.menu AS m ON a.product_id = m.product_id
WHERE row_num = 1
ORDER BY customer_id ASC;

-- 8. What is the total items and amount spent for each member before they became a member?

SELECT 
    s.customer_id,
    COUNT(s.product_id) AS item_count,
    SUM(mn.price) AS price
FROM dannys_diner.sales s
INNER JOIN dannys_diner.members m ON s.customer_id = m.customer_id
    AND s.order_date < m.join_date
INNER JOIN dannys_diner.menu mn ON s.product_id = mn.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

WITH points_count AS (
    SELECT 
        menu.product_id,
        menu.product_name,
        CASE
            WHEN product_name = 'sushi' THEN price * 20
            ELSE price * 10
        END AS points
    FROM dannys_diner.menu
)

SELECT 
    s.customer_id, 
    SUM(p.points) AS points
FROM dannys_diner.sales AS s
INNER JOIN points_count AS p ON s.product_id = p.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

WITH dates AS (
    SELECT
        customer_id, 
        join_date, 
        join_date + INTERVAL '6 days' AS first_week, 
        DATE_TRUNC('month', '2023-01-31'::DATE) + INTERVAL '1 month' - INTERVAL '1 day' AS last_date
    FROM dannys_diner.members
)

SELECT 
    d.customer_id, 
    SUM(CASE
        WHEN m.product_name = 'sushi' THEN m.price * 20
        WHEN s.order_date BETWEEN d.join_date AND d.first_week THEN m.price * 20
        ELSE m.price * 10
    END) AS points
FROM dannys_diner.sales AS s
INNER JOIN dates AS d ON s.customer_id = d.customer_id
    AND d.join_date <= s.order_date
    AND s.order_date <= d.last_date
INNER JOIN dannys_diner.menu AS m ON s.product_id = m.product_id
GROUP BY d.customer_id
ORDER BY d.customer_id;

-- Join All The Things

SELECT 
    s.customer_id, 
    s.order_date,  
    mn.product_name, 
    mn.price,
    CASE
        WHEN s.order_date >= m.join_date THEN 'Y'
        ELSE 'N'
    END AS member_status
FROM dannys_diner.sales AS s
LEFT JOIN dannys_diner.members AS m ON s.customer_id = m.customer_id
INNER JOIN dannys_diner.menu AS mn ON s.product_id = mn.product_id
ORDER BY s.customer_id, s.order_date;


-- Rank All The Things

WITH status AS (
    SELECT 
        s.customer_id, 
        s.order_date,  
        mn.product_name, 
        mn.price,
        CASE
            WHEN s.order_date >= m.join_date THEN 'Y'
            ELSE 'N'
        END AS member_status
    FROM dannys_diner.sales AS s
    LEFT JOIN dannys_diner.members AS m ON s.customer_id = m.customer_id
    INNER JOIN dannys_diner.menu AS mn ON s.product_id = mn.product_id
    ORDER BY s.customer_id, s.order_date
)

SELECT *,
    CASE
        WHEN member_status = 'Y' THEN DENSE_RANK() OVER(PARTITION BY customer_id, member_status ORDER BY order_date)
        ELSE NULL
    END AS ranking
FROM status
ORDER BY ranking ASC;
