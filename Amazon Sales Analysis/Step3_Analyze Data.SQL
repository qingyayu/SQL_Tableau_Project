#===================================================================================================================
# Add data to amazon_sale and SKU_info table and check data
#===================================================================================================================
# check total count
SELECT COUNT(*) FROM temp_amazon_sale;
SELECT COUNT(*) FROM stock;

# Populating amazon_sale table with data from temp_amazon_sale
INSERT INTO amazon_sale (
	order_id,
	date,
	status,
	fulfilment,
	sales_channel,
	ship_service_level,
	courier_status,
	quantity,
	currency,
	amount,
	ship_city,
	ship_state,
	ship_postal_code,
	ship_country,
	customer_type,
	SKU_ASIN

)
SELECT 
    order_id,
	date,
	status,
	fulfilment,
	sales_channel,
	ship_service_level,
	courier_status,
	quantity,
	currency,
	amount,
	ship_city,
	ship_state,
	ship_postal_code,
	ship_country,
	customer_type,
	SKU_ASIN
FROM temp_amazon_sale;

# Populating SKU_info table with data from temp_amazon_sale
INSERT INTO SKU_info (
	SKU_ASIN,
	style,
	SKU,
	category,
	size,
	ASIN
)
SELECT DISTINCT 
    SKU_ASIN,
	style,
	SKU,
	category,
	size,
	ASIN
FROM temp_amazon_sale;

# Check unique SKU_ASIN in the amazon_sale table and SKU_info table
SELECT COUNT(DISTINCT(SKU_ASIN))
FROM amazon_sale;
SELECT COUNT(DISTINCT(SKU_ASIN))
FROM SKU_info;

# Check rows with non-ASCII characters for inspection
SELECT ship_city
FROM amazon_sale
WHERE ship_city REGEXP '[^ -~]';

# Replace non-ASCII characters in ship_city with 'n/a'
UPDATE amazon_sale
SET ship_city = 'n/a'
WHERE ship_city REGEXP '[^ -~]';

#================================================================================
# Data Exploration
#================================================================================
# Total number of transaction
SELECT COUNT(*) AS total_number_of_transaction
FROM amazon_sale;

# Total categories
SELECT COUNT(DISTINCT(category)) AS total_categories
FROM SKU_info;

# Total quantity and amount
SELECT SUM(quantity) AS total_quantity, SUM(amount) AS total_amount
FROM amazon_sale;

# Total quantity and amount by state
SELECT ship_state, SUM(quantity) AS total_quantity, SUM(amount) AS total_amount
FROM amazon_sale
GROUP BY ship_state
ORDER BY total_amount DESC;

# Total quantity and amount by state by category
SELECT a.ship_state, Si.category, SUM(a.quantity) AS total_quantity, SUM(a.amount) AS total_amount
FROM amazon_sale a
LEFT JOIN SKU_info Si
ON a.SKU_ASIN = Si.SKU_ASIN
GROUP BY a.ship_state, Si.category
ORDER BY total_amount DESC;

# Order quantity by status of the courier
SELECT courier_status, SUM(quantity) AS total_quantity
FROM amazon_sale
GROUP BY courier_status
ORDER BY total_quantity DESC;

# Order quantity by status of the courier by status of the sale
SELECT courier_status, status, SUM(quantity) AS total_quantity
FROM amazon_sale
GROUP BY courier_status, status
ORDER BY courier_status, total_quantity DESC;

# Quantity by fulfilment type
SELECT fulfilment, SUM(quantity)
FROM amazon_sale
GROUP BY fulfilment
ORDER BY SUM(quantity) DESC;

# Quantity by customer type
SELECT customer_type, SUM(quantity)
FROM amazon_sale
GROUP BY customer_type
ORDER BY SUM(quantity) DESC;

# Analyze revenue and sales volume by category
SELECT Si.category, SUM(a.quantity) AS total_quantity, SUM(a.amount) AS total_amount
FROM amazon_sale a
LEFT JOIN SKU_info Si
ON a.SKU_ASIN = Si.SKU_ASIN
GROUP BY Si.category
ORDER BY total_quantity DESC;

# Analyze revenue by category by size
SELECT Si.category, Si.size, SUM(a.amount) AS total_amount
FROM amazon_sale a
LEFT JOIN SKU_info Si
ON a.SKU_ASIN = Si.SKU_ASIN
GROUP BY Si.category, Si.size
ORDER BY category, total_amount DESC;

# Revenue by size of top 4 categories
WITH TopCategories AS (
    SELECT 
        Si.category, 
        SUM(a.amount) AS total_revenue
    FROM 
        amazon_sale a
    LEFT JOIN 
        SKU_info Si
    ON 
        a.SKU_ASIN = Si.SKU_ASIN
    GROUP BY 
        Si.category
    ORDER BY 
        total_revenue DESC
    LIMIT 4
)
SELECT 
    Si.category, 
    Si.size, 
    SUM(a.amount) AS total_amount
FROM 
    amazon_sale a
LEFT JOIN 
    SKU_info Si
ON 
    a.SKU_ASIN = Si.SKU_ASIN
WHERE 
    Si.category IN (SELECT category FROM TopCategories)
GROUP BY 
    Si.category, Si.size
ORDER BY 
    Si.category,
    CASE Si.size
        WHEN 'XS' THEN 1
        WHEN 'S' THEN 2
        WHEN 'M' THEN 3
        WHEN 'L' THEN 4
        WHEN 'XL' THEN 5
        WHEN 'XXL' THEN 6
        WHEN '3XL' THEN 7
        WHEN '4XL' THEN 8
        WHEN '5XL' THEN 9
        WHEN '6XL' THEN 10
    END;

# Analyze revenue and sales volume by category by color
SELECT Si.category, s.color, SUM(a.amount) AS total_amount, SUM(a.quantity) AS total_quantity
FROM amazon_sale a
LEFT JOIN SKU_info Si
ON a.SKU_ASIN = Si.SKU_ASIN
LEFT JOIN stock s
ON Si.SKU = S.SKU AND Si.style = S.design_no
GROUP BY Si.category, s.color
HAVING s.color IS NOT NULL
ORDER BY category, total_amount DESC;

# Revenue of top 8 colours of top 4 categories
WITH TopCategories AS (
    SELECT 
        Si.category, 
        SUM(a.amount) AS total_revenue
    FROM 
        amazon_sale a
    LEFT JOIN 
        SKU_info Si
    ON 
        a.SKU_ASIN = Si.SKU_ASIN
    GROUP BY 
        Si.category
    ORDER BY 
        total_revenue DESC
    LIMIT 4
),
RankedData AS (
    SELECT
        Si.category,
        s.color,
        SUM(a.amount) AS total_amount,
        SUM(a.quantity) AS total_quantity,
        ROW_NUMBER() OVER (PARTITION BY Si.category ORDER BY SUM(a.amount) DESC) AS amount_rank
    FROM
        amazon_sale a
    LEFT JOIN
        SKU_info Si
    ON
        a.SKU_ASIN = Si.SKU_ASIN
    LEFT JOIN
        stock s
    ON
        Si.SKU = s.SKU AND Si.style = s.design_no
    WHERE 
        Si.category IN (SELECT category FROM TopCategories)
    GROUP BY 
        Si.category, s.color
	HAVING s.color IS NOT NULL
)
SELECT
    category,
    color,
    total_amount,
    total_quantity
FROM 
    RankedData
WHERE
    amount_rank <= 8
ORDER BY 
    category, total_amount DESC;


# How does the choice of shipping service level (standard or expedited) affect revenue
SELECT ship_service_level, SUM(quantity) AS total_quantity, SUM(amount) AS total_amount
FROM amazon_sale
GROUP BY ship_service_level;

# Analyze the relationship between shipping service level and the category, comparing the expedited and standard ship service rate between each category and the average rates.
SELECT 
    Si.category,
    a.ship_service_level,
    SUM(a.quantity) AS total_quantity,
    SUM(a.amount) AS total_amount,
    SUM(a.quantity)/(
		SELECT SUM(a_sub.quantity)
		FROM amazon_sale a_sub
		LEFT JOIN SKU_info Si_sub
		ON a_sub.SKU_ASIN = Si_sub.SKU_ASIN
        WHERE Si.category = Si_sub.category) AS quantity_rate,
	SUM(a.amount)/(
		SELECT SUM(a_sub.amount)
		FROM amazon_sale a_sub
		LEFT JOIN SKU_info Si_sub
		ON a_sub.SKU_ASIN = Si_sub.SKU_ASIN
        WHERE Si.category = Si_sub.category) AS amount_rate,
	(SELECT SUM(quantity) 
		FROM amazon_sale
		WHERE ship_service_level = a.ship_service_level)/
	(SELECT SUM(quantity)
		FROM amazon_Sale) AS avg_quantity_rate,
	(SELECT SUM(amount) 
		FROM amazon_sale
		WHERE ship_service_level = a.ship_service_level)/
	(SELECT SUM(amount)
		FROM amazon_Sale) AS avg_amount_rate
FROM amazon_sale a
LEFT JOIN SKU_info Si
ON a.SKU_ASIN = Si.SKU_ASIN
GROUP BY Si.category, a.ship_service_level
ORDER BY Si.category DESC;

# Top 10 products by revenue
SELECT Si.SKU, Si.category, Si.size, S.color, SUM(a.amount) AS total_amount
FROM amazon_sale a
LEFT JOIN SKU_info Si
ON a.SKU_ASIN = Si.SKU_ASIN
LEFT JOIN stock s
ON Si.SKU = S.SKU AND Si.style = S.design_no
GROUP BY Si.SKU, Si.category, Si.size, S.color
ORDER BY total_amount DESC
LIMIT 10;

# Analyze sales revenue trend over time (daily)
SELECT date, SUM(amount) AS total_amount
FROM amazon_sale
GROUP BY date
ORDER BY date;

# Analyze sales revenue and order quantity trend over time (monthly)
SELECT MONTH(date) as month, SUM(amount) AS total_amount
FROM amazon_sale
GROUP BY month
ORDER BY month;

# Total amount sold by category by month
SELECT MONTH(a.date) AS month, Si.category, SUM(a.amount) AS total_amount
FROM amazon_sale a
JOIN SKU_info Si ON a.SKU_ASIN = Si.SKU_ASIN
GROUP BY month, Si.category
ORDER BY month, total_amount DESC;

# Total amount sold by category by day
SELECT a.date, Si.category, SUM(a.amount) AS total_amount
FROM amazon_sale a
JOIN SKU_info Si ON a.SKU_ASIN = Si.SKU_ASIN
GROUP BY a.date, Si.category
ORDER BY date, total_amount DESC;
