-- =========================================
-- Удаляем таблицу если существует
-- =========================================
DROP TABLE IF EXISTS products;

-- =========================================
-- Создание таблицы
-- =========================================
CREATE TABLE products (

    id SERIAL PRIMARY KEY,

    name VARCHAR(100) NOT NULL UNIQUE,

    type VARCHAR(50) NOT NULL,

    price NUMERIC(10,2) NOT NULL
        CHECK (price > 0),

    size_x NUMERIC(10,2) NOT NULL
        CHECK (size_x > 0),

    size_y NUMERIC(10,2) NOT NULL
        CHECK (size_y > 0),

    is_available BOOLEAN NOT NULL DEFAULT TRUE,

    sub_type VARCHAR(50),

    rating NUMERIC(3,2)
        CHECK (rating BETWEEN 0 AND 5),

    weight NUMERIC(10,2)
        CHECK (weight > 0),

    area NUMERIC GENERATED ALWAYS AS (size_x * size_y) stored
    
);

-- =========================================
-- Вставка одного продукта
-- =========================================
INSERT INTO products
(name, type, price, size_x, size_y, is_available, sub_type, rating, weight)
VALUES
('Table', 'Furniture', 120.50, 2.0, 1.5, TRUE, 'Wood', 4.5, 25.0);

-- =========================================
-- Вставка N записей через цикл
-- =========================================
DO $$
DECLARE
    i INT := 1;
    N INT := 10;
BEGIN

WHILE i <= N LOOP

	INSERT INTO products
	(name, type, price, size_x, size_y, is_available, sub_type, rating, weight)
	VALUES
	(
	    'Product_' || i,
	    'TestType',
	    10 + i,
	    1 + i * 0.1,
	    1 + i * 0.2,
	    TRUE,
	    'Subtype',
	    3 + i * 0.1,
	    5 + i
	);
	
	i := i + 1;

END LOOP;

END $$;

INSERT INTO products (name, type, price, size_x, size_y, is_available, sub_type, rating, weight)
VALUES
('Test_NULL_1', 'TestType', 10, 1, 1, TRUE, 'Subtype', NULL, 5),
('Test_NULL_1', 'TestType', 12, 1.2, 1.2, TRUE, 'Subtype', NULL, 6)
ON CONFLICT (name) DO NOTHING;

-- Добавляем тестовые строки с weight NULL
INSERT INTO products (name, type, price, size_x, size_y, is_available, sub_type, rating, weight)
VALUES
('Test_Weight_NULL_1', 'TestType', 15, 1.5, 1.5, TRUE, 'Subtype', 4.0, NULL),
('Test_Weight_NULL_2', 'TestType', 18, 1.8, 1.8, TRUE, 'Subtype', 4.5, NULL);