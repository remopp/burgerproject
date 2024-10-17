USE burger;

-- Drop existing tables to reset
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS CustomBurger_Ingredients;
DROP TABLE IF EXISTS CustomBurgers;
DROP TABLE IF EXISTS Burger_Ingredients;
DROP TABLE IF EXISTS Burgers;
DROP TABLE IF EXISTS Ingredients;
DROP TABLE IF EXISTS Customers;

-- Customers table to store customer information
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL DEFAULT 'None'
);

-- Ingredients table to store all available ingredients
CREATE TABLE Ingredients (
    ingredient_id INT PRIMARY KEY AUTO_INCREMENT,
    ingredient_name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- Burgers table to store predefined burgers (unchangeable)
CREATE TABLE Burgers (
    burger_id INT PRIMARY KEY AUTO_INCREMENT,
    burger_name VARCHAR(255) NOT NULL
);

-- Burger_Ingredients table to store default ingredients for predefined burgers
CREATE TABLE Burger_Ingredients (
    burger_id INT,
    ingredient_id INT,
    PRIMARY KEY (burger_id, ingredient_id),
    FOREIGN KEY (burger_id) REFERENCES Burgers(burger_id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES Ingredients(ingredient_id) ON DELETE CASCADE
);

-- CustomBurgers table for storing user-customized versions of burgers
CREATE TABLE CustomBurgers (
    custom_burger_id INT PRIMARY KEY AUTO_INCREMENT,
    session_id VARCHAR(255),  -- A way to track the session or user
    burger_id INT,  -- The original burger being customized
    custom_name VARCHAR(255),  -- Custom burger name
    total_price DECIMAL(10, 2),
    FOREIGN KEY (burger_id) REFERENCES Burgers(burger_id) ON DELETE CASCADE
);

-- CustomBurger_Ingredients table to store the ingredients for a customized burger
CREATE TABLE CustomBurger_Ingredients (
    custom_burger_id INT,
    ingredient_id INT,
    quantity INT DEFAULT 1, -- Field for tracking the quantity of each ingredient
    PRIMARY KEY (custom_burger_id, ingredient_id),
    FOREIGN KEY (custom_burger_id) REFERENCES CustomBurgers(custom_burger_id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES Ingredients(ingredient_id) ON DELETE CASCADE
);

-- Orders table to store customer orders, including customized burgers
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    custom_burger_id INT,
    total_price DECIMAL(10, 2),
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'completed') DEFAULT 'pending',  -- Add status to track order state
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (custom_burger_id) REFERENCES CustomBurgers(custom_burger_id) ON DELETE CASCADE
);

-- FinalBurgers table to store finalized burgers (ordered burgers)
CREATE TABLE FinalBurgers (
    final_burger_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    custom_burger_name VARCHAR(255),
    total_price DECIMAL(10, 2),
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);

-- FinalBurger_Ingredients table to store ingredients of finalized burgers
CREATE TABLE FinalBurger_Ingredients (
    final_burger_id INT,
    ingredient_id INT,
    quantity INT DEFAULT 1,
    PRIMARY KEY (final_burger_id, ingredient_id),
    FOREIGN KEY (final_burger_id) REFERENCES FinalBurgers(final_burger_id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES Ingredients(ingredient_id) ON DELETE CASCADE
);

-- Update customer_id in Orders where order_id is 1
UPDATE Orders
SET customer_id = 1 -- assuming the customer ID is known
WHERE order_id = 1;
