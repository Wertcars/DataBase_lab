DROP TABLE IF EXISTS product_tags;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS discounts;
DROP TABLE IF EXISTS product_details;
DROP TABLE IF EXISTS categories cascade;
DROP TABLE IF EXISTS products cascade; 

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

-- 1 -> many
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

ALTER TABLE products
ADD COLUMN category_id INT;

ALTER TABLE products
ADD CONSTRAINT fk_products_category
FOREIGN KEY (category_id) REFERENCES categories(id);


-- 1 -> 1
CREATE TABLE product_details (
    product_id INT PRIMARY KEY,
    description TEXT,
    manufacturer TEXT,

    CONSTRAINT fk_details_product
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 1 -> 0...1
CREATE TABLE discounts (
    id SERIAL PRIMARY KEY,
    product_id INT unique NOT null,
    discount_percent NUMERIC CHECK (discount_percent >= 0),

    CONSTRAINT fk_discount_product
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- many -> many
CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

CREATE TABLE product_tags (
    product_id INT,
    tag_id INT,

    PRIMARY KEY (product_id, tag_id),

    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (tag_id) REFERENCES tags(id)
);

INSERT INTO categories (name) VALUES
('Furniture'),
('Electronics'),
('Clothing');

INSERT INTO products (name, type, price, size_x, size_y, is_available, category_id)
VALUES
('Table', 'Furniture', 120, 2, 1.5, TRUE, 1),
('Chair', 'Furniture', 50, 1, 1, TRUE, 1),
('Laptop', 'Electronics', 1000, 0.3, 0.2, TRUE, 2),
('T-Shirt', 'Clothing', 25, 0.5, 0.7, TRUE, 3);

INSERT INTO product_details (product_id, description, manufacturer)
VALUES
(1, 'Wooden table', 'IKEA'),
(2, 'Comfort chair', 'IKEA'),
(3, 'Gaming laptop', 'Dell'),
(4, 'Cotton T-shirt', 'H&M');

INSERT INTO discounts (product_id, discount_percent)
VALUES
(1, 10),
(3, 15);

INSERT INTO tags (name) VALUES
('New'),
('Sale'),
('Popular');

INSERT INTO product_tags (product_id, tag_id)
VALUES
(1, 1),
(1, 3),
(2, 3),
(3, 1),
(3, 2),
(4, 2);

-- 1. Кількість товарів у кожній категорії
SELECT c.name AS category, COUNT(p.id) AS product_count
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
GROUP BY c.name;

-- 2. Середня ціна товарів по категоріях
SELECT c.name AS category, AVG(p.price) AS avg_price
FROM products p
JOIN categories c ON p.category_id = c.id
GROUP BY c.name;

-- 3. Кількість тегів у кожного товару
SELECT p.name, COUNT(pt.tag_id) AS tag_count
FROM products p
LEFT JOIN product_tags pt ON p.id = pt.product_id
GROUP BY p.name;

-- 4. Максимальна знижка по категоріях
SELECT c.name AS category, MAX(d.discount_percent) AS max_discount
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
LEFT JOIN discounts d ON p.id = d.product_id
GROUP BY c.name;

-- 5. Кількість товарів у кожного виробника
SELECT pd.manufacturer, COUNT(p.id) AS product_count
FROM product_details pd
JOIN products p ON pd.product_id = p.id
GROUP BY pd.manufacturer;

-- 6. Категорії, де більше 1 товару (HAVING)
SELECT c.name AS category, COUNT(p.id) AS product_count
FROM categories c
JOIN products p ON c.id = p.category_id
GROUP BY c.name
HAVING COUNT(p.id) > 1;

-- 7. Середня ціна товарів з тегом
SELECT t.name AS tag, AVG(p.price) AS avg_price
FROM tags t
JOIN product_tags pt ON t.id = pt.tag_id
JOIN products p ON pt.product_id = p.id
GROUP BY t.name;