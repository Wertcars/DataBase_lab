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

-- 1. INNER JOIN (товари + категорії)
SELECT p.name, c.name AS category
FROM products p
INNER JOIN categories c ON p.category_id = c.id;

-- 2. LEFT JOIN (всі товари + знижки)
SELECT p.name, d.discount_percent
FROM products p
LEFT JOIN discounts d ON p.id = d.product_id;

-- 3. RIGHT JOIN (знижки + товари)
SELECT p.name, d.discount_percent
FROM products p
RIGHT JOIN discounts d ON p.id = d.product_id;

-- 4. FULL JOIN (товари + знижки)
SELECT p.name, d.discount_percent
FROM products p
FULL JOIN discounts d ON p.id = d.product_id;

-- 5. JOIN many-to-many (товари + теги)
SELECT p.name, t.name AS tag
FROM products p
JOIN product_tags pt ON p.id = pt.product_id
JOIN tags t ON pt.tag_id = t.id;

-- 6. LEFT JOIN (товари + деталі)
SELECT p.name, pd.description
FROM products p
LEFT JOIN product_details pd ON p.id = pd.product_id;

-- 7. RIGHT JOIN (деталі + товари)
SELECT p.name, pd.manufacturer
FROM products p
RIGHT JOIN product_details pd ON p.id = pd.product_id;

-- 8. FULL JOIN (категорії + товари)
SELECT c.name AS category, p.name AS product
FROM categories c
FULL JOIN products p ON c.id = p.category_id;

-- 9. CROSS JOIN (всі комбінації товарів і тегів)
SELECT p.name, t.name
FROM products p
CROSS JOIN tags t;

-- 10. LEFT JOIN (товари без знижки)
SELECT p.name
FROM products p
LEFT JOIN discounts d ON p.id = d.product_id
WHERE d.id IS NULL;