select * from products;

-- Створює віртуальну таблицю з обмеженим доступом --
CREATE OR REPLACE VIEW products_view AS
SELECT
    id,
    name,
    type,
    price,
    size_x,
    size_y,
    size_x * size_y AS area,
    CASE 
        WHEN is_available THEN 'Available'
        ELSE 'Not Available'
    END AS status
FROM products;

select * from products_view;

-- Рахує ціну за розміром(скалярна функція) --
CREATE OR REPLACE function get_price_per_area(p_id INT)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN (
        SELECT round(price / (size_x * size_y), 2)
        FROM products
        WHERE id = p_id
    );
END;
$$;

SELECT get_price_per_area(1);

-- Виводе таблицю з умовою WHERE is_available = TRUE(таблична функція) --
CREATE OR REPLACE FUNCTION get_available_products()
RETURNS TABLE (
    id INT,
    name TEXT,
    price NUMERIC
)
LANGUAGE sql
AS $$
    SELECT id, name, price
    FROM products
    WHERE is_available = TRUE;
$$;

SELECT * FROM get_available_products();

-- Створює вид таблиці products_history--
CREATE TABLE IF NOT EXISTS products_history (
    id SERIAL PRIMARY KEY,
    product_id INT,
    name TEXT,
    action_type TEXT,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Функція за трігером --
CREATE OR REPLACE FUNCTION products_history_trigger()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    -- INSERT --
    IF TG_OP = 'INSERT' THEN
        INSERT INTO products_history(product_id, name, action_type)
        SELECT id, name, 'INSERT'
        FROM new_table;

    -- UPDATE --
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO products_history(product_id, name, action_type)
        SELECT id, name, 'UPDATE'
        FROM new_table;

    -- DELETE --
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO products_history(product_id, name, action_type)
        SELECT id, name, 'DELETE'
        FROM old_table;
    END IF;

    RETURN NULL;
END;
$$;

DROP TRIGGER IF EXISTS trg_products_history_insert ON products;
DROP TRIGGER IF EXISTS trg_products_history_update ON products;
DROP TRIGGER IF EXISTS trg_products_history_delete ON products;

-- Insert trigger --
CREATE TRIGGER trg_products_history_insert
AFTER INSERT ON products
REFERENCING NEW TABLE AS new_table
FOR EACH STATEMENT
EXECUTE FUNCTION products_history_trigger();

-- Update trigger --
CREATE TRIGGER trg_products_history_update
AFTER UPDATE ON products
REFERENCING NEW TABLE AS new_table
FOR EACH STATEMENT
EXECUTE FUNCTION products_history_trigger();

-- Delete trigger
CREATE TRIGGER trg_products_history_delete
AFTER DELETE ON products
REFERENCING OLD TABLE AS old_table
FOR EACH STATEMENT
EXECUTE FUNCTION products_history_trigger();

-- Очищення таблиці --
TRUNCATE TABLE products_history RESTART IDENTITY;

-- 1. INSERT --
INSERT INTO products (name, type, price, size_x, size_y, is_available)
VALUES ('Trigger_Test', 'TestType', 50, 2, 2, TRUE);

-- 2. UPDATE --
UPDATE products
SET price = price + 10
WHERE name = 'Trigger_Test';

-- 3. DELETE --
DELETE FROM products
WHERE name = 'Trigger_Test';

SELECT * FROM products_history
ORDER BY action_time DESC;

-- Об'єднує 2 таблиці -- 
SELECT 
    id,
    name,
    'EXISTING' AS status
from products

UNION ALL

SELECT 
    product_id AS id,
    name,
    'DELETED' AS status
FROM products_history
WHERE action_type = 'DELETE';

-- --
CREATE OR REPLACE PROCEDURE generate_products(p_count INT DEFAULT 5)
LANGUAGE plpgsql
AS $$
DECLARE
    i INT;
BEGIN
    FOR i in 1..p_count LOOP
        INSERT INTO products
        (name, type, price, size_x, size_y, is_available, sub_type, rating, weight)
        VALUES (
            'Gen_Product_' || i,
            'Generated',
            10 + i,
            1 + i * 0.1,
            1 + i * 0.2,
            TRUE,
            'Auto',
            ROUND(3 + i * 0.1, 1),
            5 + i
        )
		ON CONFLICT (name) DO NOTHING;
    END LOOP;

END;
$$;

call generate_products(20);
select * from products;