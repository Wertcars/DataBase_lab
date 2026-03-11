-- =========================================
-- 20 SQL запросов
-- =========================================

-- 1
SELECT * FROM products;

-- 2
SELECT * FROM products
LIMIT 5;

-- 3
SELECT name, price FROM products;

-- 4
SELECT * FROM products
ORDER BY price DESC;

-- 5
SELECT * FROM products
WHERE price BETWEEN 10 AND 50;

-- 6
SELECT * FROM products
WHERE name LIKE 'Product%';

-- 7
SELECT * FROM products
WHERE type IN ('Furniture', 'TestType');

-- 8
SELECT * FROM products
WHERE sub_type IS NULL;

-- 9
SELECT * FROM products
WHERE sub_type IS NOT NULL;

-- 10
SELECT * FROM products
WHERE price > 20 AND rating > 3;

-- 11
SELECT * FROM products
WHERE price > 50 OR weight > 20;

-- 12
SELECT * FROM products
WHERE NOT type = 'Furniture';

-- 13
SELECT * FROM products
ORDER BY price
LIMIT 5 OFFSET 5;

-- 14
UPDATE products
SET price = price * 1.1
WHERE price IS NOT NULL;
SELECT * FROM products;

-- 15
UPDATE products
SET rating = 5
WHERE rating IS NULL;
SELECT * FROM products;

-- 16
UPDATE products
SET is_available = FALSE
WHERE weight IS NULL;
SELECT * FROM products;

-- 17
SELECT MAX(price) AS max_price,
       MIN(price) AS min_price
FROM products;

-- 18
SELECT COUNT(*) AS total_products
FROM products;

-- 19
SELECT AVG(price) AS average_price
FROM products;

-- 20
DELETE FROM products
WHERE price < 15;
SELECT * FROM products;