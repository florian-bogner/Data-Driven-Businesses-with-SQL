USE magist;

SELECT * FROM products;

SELECT product_id, COUNT(product_category_name)
FROM products;

SELECT * 
FROM products
LIMIT 10;

SELECT * 
FROM products
WHERE product_category_name = "cool_stuff";

SELECT *
FROM products
WHERE product_category_name = "cool_stuff" OR product_category_name = "consoles_games";

SELECT COUNT(*)
FROM products
WHERE product_category_name = "cool_stuff";

SELECT DISTINCT product_category_name
FROM products;

SELECT *
FROM order_payments
ORDER BY payment_value DESC; # ORDER BY kommt immer nach allen Klauseln, wie WHERE, GROUP BY, HAVING; erst dann ORDER BY

SELECT payment_type, COUNT(*) AS n_orders
FROM order_payments
GROUP BY payment_type; # GROUP BY ist nötig, wenn mehr als eine Spalte ausgewählt ist,
#von der mindestens eine über eine Aggregatfunktion kollabiert wird. Es sei denn, man ändert wohl die NLY_FULL_GROUP_BY-Einstellung

SELECT payment_type, COUNT(*) AS n_orders, payment_value
FROM order_payments 
GROUP BY payment_type; #Produziert fehler, da payment_value weder aggregiert wird, noch im GROUP BY präsent ist

#LÖSUNG 1 für Abfrage darüber: payment_value in GROUP BY präsent machen
SELECT payment_type, COUNT(*) AS n_orders, payment_value
FROM order_payments 
GROUP BY payment_type, payment_value;

#LÖSUNG 1 für Abfrage oberhalb von LÖSUNG 1: payment_value aggregieren durch Mittelwert AVG()
SELECT payment_type, COUNT(*) AS n_orders, AVG(payment_value) AS avg_payment
FROM order_payments 
GROUP BY payment_type;

SELECT payment_type, COUNT(*) AS n_orders, ROUND(AVG(payment_value)) AS avg_payment
FROM order_payments 
GROUP BY payment_type;

SELECT payment_type, COUNT(*) AS n_orders, ROUND(AVG(payment_value), 2) AS avg_payment
FROM order_payments 
GROUP BY payment_type;

SELECT payment_type, COUNT(*) AS n_orders, ROUND(AVG(payment_value), 2) AS avg_payment
FROM order_payments
GROUP BY payment_type
HAVING n_orders >1000;

#GENERELLE ANFRAGENSTRUKTUR
SELECT payment_type, ROUND(AVG(payment_value)) avg_payment
FROM order_payments
WHERE payment_value > 100
GROUP BY payment_type
HAVING avg_payment > 230
ORDER BY avg_payment DESC
LIMIT 1;

SELECT COUNT(*) orders_count
FROM orders;