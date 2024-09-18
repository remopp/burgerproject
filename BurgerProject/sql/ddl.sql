USE burger;

DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Burger_Ingredients;
DROP TABLE IF EXISTS Burgers;
DROP TABLE IF EXISTS Ingredients;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE Ingredients (
    ingredient_id INT PRIMARY KEY AUTO_INCREMENT,
    ingredient_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Burgers (
    burger_id INT PRIMARY KEY AUTO_INCREMENT,
    burger_name VARCHAR(255) NOT NULL
);

CREATE TABLE Burger_Ingredients (
    burger_id INT,
    ingredient_id INT,
    PRIMARY KEY (burger_id, ingredient_id),
    FOREIGN KEY (burger_id) REFERENCES Burgers(burger_id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES Ingredients(ingredient_id) ON DELETE CASCADE
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    burger_id INT,
    customized_ingredient_ids TEXT,
    total_price DECIMAL(10, 2),
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (burger_id) REFERENCES Burgers(burger_id)
);
