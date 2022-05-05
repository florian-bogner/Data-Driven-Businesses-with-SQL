USE magist;

############################################################################################################################################################################################
# 1.0 In relation to the products:
############################################################################################################################################################################################
# 1.1 What categories of tech products does Magist have?
SELECT product_category_name_english																				# (1) Da diese Liste nur dafür da ist, Produktkategorien zu listen, braucht man kein DISTINCT. Hier wird die Spalte gewählt, die die englischen Übersetzungen listet		
FROM product_category_name_translation																				# (2) Die Spalte aus (1) nehme ich aus dieser Tabelle
ORDER BY product_category_name_english																				# (3) Das sortiert die englischen Übersetzungen noch aufsteigend
;																													# (4) Output: Liste mit den Kategorien, aus denen ich die folgenden ausgesucht habe:
																														/*
																														'computers'
																														'computers_accessories'
																														'consoles_games'
																														'electronics'
																														'fixed_telephony'
																														'pc_gamer'
																														'tablets_printing_image'
																														'telephony'
																														*/

############################################################################################################################################################################################

# 1.2 How many products of these tech categories have been sold (within the time window of the database snapshot)? What percentage does that represent from the overall number of products sold?
SELECT 

(SELECT COUNT(product_id)  																		# (1) Wähle Spalte als Zahlung aller Zeilen. Die Spalte bekommt ein Alias
	FROM order_items o) all_products_sold, 
    
    COUNT(*) tech_products_sold,

COUNT(*)*100/(SELECT COUNT(product_id) all_products_sold  															# (1) Wähle Spalte als Zahlung aller Zeilen. Die Spalte bekommt ein Alias
	FROM order_items o) percent

FROM order_items o																									# (2) Die Spalte aus (1) kommt aus der Tabelle und bekommt ein Alias
LEFT JOIN products p ON o.product_id = p.product_id																	# (3) Die Tabelle aus (2) wir leftgejoint mit einer Tabelle, die ein Alias bekommt. Das Joinen passiert über Tabellenalias.Key
LEFT JOIN product_category_name_translation pcnt ON p.product_category_name = pcnt.product_category_name			# (4) Die Tabelle aus (3) wird leftgejoint mit einer Tabelle, die ein Alias bekommt. Das Joinen passiert über Tabellenalias.Key
WHERE pcnt.product_category_name_english IN (																		# (5) WHERE wählt aus Tabellenalias.Spalte Werte aus, die über IN festgelegt werden
	'computers',																									# (6) Nach diesen Techkategorien wird gesucht und alle verkauften Produkte dieser Kategorien werden dann zusammengezählt,...
    'computers_accessories',
    'consoles_games',
    'electronics',
    'fixed_telephony',
    'pc_gamer',
    'tablets_printing_image',
    'telephony'
    )
;																													# (7) ... was dann 16835 verkaufte Techprodukte wären.

SELECT COUNT(product_id) products_sold																				# (1) Wähle Produk-IDs und zähle sie alle zusammen, was dann in der Spalte products_sold ausgegeben wird. Das heißt, dass alle verkaufen Produkte unanhängig ihrer Kategorie gewählt werden.
FROM order_items																									# (2) Die Spalte aus (1) kommt aus der Tabelle order_items
;																													# (3) Es gibt 112650 verkaufte Produkte aller Kategorien

# Dimitrys Lösung
SELECT pcnt.product_category_name_english AS eng_cat_name, ROUND(COUNT(oi.product_id)*100/(SELECT COUNT(product_id) from order_items),2) AS percent_products
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation pcnt ON p.product_category_name = pcnt.product_category_name
WHERE pcnt.product_category_name_english IN (
	'computers',
	'computers_accessories',
	'consoles_games',
	'electronics',
	'fixed_telephony',
	'pc_gamer',
	'tablets_printing_image',
	'telephony'
    )
GROUP BY pcnt.product_category_name_english
ORDER BY percent_products DESC
;

SELECT COUNT(*)
FROM order_items;

# Marcus Lösung:
SELECT SUM(order_count) AS orders_tech FROM
    (SELECT product_category_name_translation.product_category_name_english AS product_category, 
    COUNT(order_items.order_id) AS order_count FROM products
        JOIN product_category_name_translation 
            ON product_category_name_translation.product_category_name = products.product_category_name
        JOIN order_items
            ON products.product_id = order_items.product_id
        GROUP BY products.product_category_name
        ORDER BY COUNT(order_items.order_id) DESC) AS orders_by_category
    WHERE product_category IN (
'computers',
'computers_accessories',
'consoles_games',
'electronics',
'fixed_telephony',
'pc_gamer',
'tablets_printing_image',
'telephony'
);

############################################################################################################################################################################################

# 1.3 What’s the average price of the products being sold?

SELECT AVG(avg_price) grand_avg_price
FROM (
SELECT product_id, AVG(price) avg_price
FROM order_items
GROUP BY product_id) single_avg_price
;

############################################################################################################################################################################################

# 1.4 Are expensive tech products popular? (TIP: Look at the function CASE WHEN to accomplish this task.)
# Preise der eindeutigen Produkte

SELECT product_id, AVG(price) avg_price, COUNT(order_id) order_count
FROM order_items
LEFT JOIN orders USING (order_id)
GROUP BY product_id
;

SELECT SUM(order_count) sum_of_orders_within_price_category,
	CASE
		WHEN avg_price BETWEEN 0 AND 1000 THEN "inexpensive"
        WHEN avg_price BETWEEN 1000 AND 5000 THEN "moderate"
        ELSE "expensive" END price_category
FROM
(SELECT product_id, AVG(price) avg_price, COUNT(order_id) order_count
FROM order_items
LEFT JOIN orders USING (order_id)
GROUP BY product_id) avg_price_order_count_per_product
GROUP BY price_category;

# DIMITRYs LÖSUNG --> Brazil only offers 3% fpr tech products
SELECT 
    pcnt.product_category_name_english AS eng_cat_name,
    COUNT(oi.product_id)*100/(SELECT COUNT(product_id) from order_items)    
    AS percent_products
FROM
    order_items oi
        LEFT JOIN
    products p ON oi.product_id = p.product_id
        LEFT JOIN
    product_category_name_translation pcnt ON p.product_category_name = pcnt.product_category_name
WHERE
    pcnt.product_category_name_english IN (
        'computers',
        'computers_accessories',
        'consoles_games',
        'electronics',
        'fixed_telephony',
        'pc_gamer',
        'tablets_printing_image',
        'telephony')
AND
     oi.price > 121   
#comment GROUP BY and ORDER BY to get total number of products in all these categories        
GROUP BY pcnt.product_category_name_english
ORDER BY percent_products DESC
;

# MARCUS' LÖSUNG --> 
SELECT CASE
    WHEN price <= 100 THEN '0-100'
    WHEN 100 < price AND price <= 500 THEN '100-500'
    WHEN 500 < price AND price <= 1000 THEN '500-1000'
    WHEN 1000 < price AND price <= 1500 THEN '1000-1500'
    WHEN 1500 < price AND price <= 2000 THEN '1500-2000'
    WHEN 2000 < price AND price <= 2500 THEN '2000-2500'
    WHEN 2500 < price AND price <= 3000 THEN '2500-3000'
    ELSE 'expensive' END AS price_category, COUNT(*)
    FROM order_items
    JOIN products USING(product_id)
    JOIN product_category_name_translation USING(product_category_name)
    WHERE product_category_name_translation.product_category_name_english 
        IN ('computers',
'computers_accessories',
'consoles_games',
'electronics',
'fixed_telephony',
'pc_gamer',
'tablets_printing_image',
'telephony')
    GROUP BY price_category
    ORDER BY COUNT(*) DESC;
    
############################################################################################################################################################################################
# 2.0 In relation to the sellers:
############################################################################################################################################################################################
# 2.1 How many sellers are there?
SELECT COUNT(seller_id)
FROM sellers;

############################################################################################################################################################################################

# 2.2 What’s the average monthly revenue of Magist’s sellers?
# Das wird die derived table:
SELECT 
    seller_id,
    MONTH(shipping_limit_date) month_,
    YEAR(shipping_limit_date) year_,
    SUM(price) monthly_rev
FROM
    order_items
GROUP BY seller_id , YEAR(shipping_limit_date) , MONTH(shipping_limit_date)
ORDER BY seller_id , MONTH(shipping_limit_date) , YEAR(shipping_limit_date);

SELECT COUNT(DISTINCT seller_id)
FROM order_items;

SELECT COUNT(*)
FROM sellers;

# Die obere derived table wird hier eingesetzt:
SELECT AVG(monthly_rev)
FROM (SELECT																						# Beginn der derived table
    seller_id,
	MONTH(shipping_limit_date) month_,
    YEAR(shipping_limit_date) year_,
    SUM(price) monthly_rev
FROM
    order_items
GROUP BY seller_id , YEAR(shipping_limit_date) , MONTH(shipping_limit_date))monthly_rev;			# Ende der derived table






############################################################################################################################################################################################

# 2.3 What’s the average revenue of sellers that sell tech products?

SELECT 
    AVG(monthly_rev) avg_monthly_rev
FROM
    (SELECT 
        seller_id,
            MONTH(shipping_limit_date) month_,
            SUM(price) monthly_rev
    FROM
        order_items
    GROUP BY seller_id , YEAR(shipping_limit_date) , MONTH(shipping_limit_date)) monthly_seller_rev
LEFT JOIN ON products USING (product_id)
LEFT JOIN ON product_category_name_translation USING (product_category_name)
WHERE product_category_name_translation.product_category_name_english 
        IN ('computers',
'computers_accessories',
'consoles_games',
'electronics',
'fixed_telephony',
'pc_gamer',
'tablets_printing_image',
'telephony');









# DIMITRY
SELECT AVG(total_reveue)
FROM 
(SELECT 
    oi.seller_id,
    ROUND(SUM(oi.price),2) AS total_reveue
FROM
    order_items oi
        LEFT JOIN
    products p ON oi.product_id = p.product_id
        LEFT JOIN
    product_category_name_translation pcnt ON p.product_category_name = pcnt.product_category_name
WHERE
    pcnt.product_category_name_english IN (
        'computers',
        'computers_accessories',
        'consoles_games',
        'electronics',
        'fixed_telephony',
        'pc_gamer',
        'tablets_printing_image',
        'telephony')
GROUP BY oi.seller_id
ORDER BY total_reveue DESC)

;
; # --> AVG(total_revenue) = 3867.83

############################################################################################################################################################################################
# 3.0 In relation to the delivery time:
############################################################################################################################################################################################
# 3.1 What’s the average time between the order being placed and the product being delivered?
# DIMITRY
SELECT 
    AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp))
FROM
    orders
;

# 3.2 How many orders are delivered on time vs orders delivered with a delay?
# DIMITRY
SELECT 
    count(order_id) AS delivered_on_time, 
    (SELECT count(order_id) FROM orders) AS total_orders,
    count(order_id)*100/(SELECT count(order_id) FROM orders) AS percent_on_time
FROM
    orders
WHERE DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) >= 0
;

# 3.3 Is there any pattern for delayed orders, e.g. big products being delayed more often?
SELECT 
CASE
	WHEN DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) - DATEDIFF(order_estimated_delivery_date, order_purchase_timestamp) > 0 THEN 'not in time'
	WHEN DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) - DATEDIFF(order_estimated_delivery_date, order_purchase_timestamp) <= 0 THEN 'in time'
	ELSE 'not delivered' END AS on_time,
    AVG(p.product_weight_g),
    AVG(product_length_cm),
    AVG(product_height_cm),
    AVG(product_width_cm)
    #p.product_category_name
FROM
    orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p ON p.product_id = oi.product_id
WHERE DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) < 0
GROUP BY on_time
;