use burger;

-- Drop and recreate the GetAllBurgers procedure
DROP PROCEDURE IF EXISTS GetAllBurgers;
DELIMITER //
CREATE PROCEDURE GetAllBurgers()
BEGIN
    SELECT b.burger_id, b.burger_name, SUM(i.price) AS burger_price
    FROM Burgers b
    JOIN Burger_Ingredients bi ON b.burger_id = bi.burger_id
    JOIN Ingredients i ON bi.ingredient_id = i.ingredient_id
    GROUP BY b.burger_id, b.burger_name;
END //
DELIMITER ;


-- Drop and recreate the GetBurgerIngredients procedure
DROP PROCEDURE IF EXISTS GetBurgerIngredients;
DELIMITER //
CREATE PROCEDURE GetBurgerIngredients(IN selected_burger_id INT)
BEGIN
    SELECT i.ingredient_id, i.ingredient_name, i.price
    FROM Ingredients i
    JOIN Burger_Ingredients bi ON i.ingredient_id = bi.ingredient_id
    WHERE bi.burger_id = selected_burger_id;
END //
DELIMITER ;


-- Drop and recreate the CreateCustomBurger procedure
DROP PROCEDURE IF EXISTS CreateCustomBurger;
DELIMITER //
CREATE PROCEDURE CreateCustomBurger(IN session_id VARCHAR(255), IN burger_id INT)
BEGIN
    -- Insert a new custom burger
    INSERT INTO CustomBurgers (session_id, burger_id, custom_name, total_price)
    SELECT session_id, b.burger_id, b.burger_name, SUM(i.price)
    FROM Burgers b
    JOIN Burger_Ingredients bi ON b.burger_id = bi.burger_id
    JOIN Ingredients i ON bi.ingredient_id = i.ingredient_id
    WHERE b.burger_id = burger_id
    GROUP BY b.burger_id;

    -- Get the custom burger ID
    SET @custom_burger_id = LAST_INSERT_ID();

    -- Insert ingredient IDs and set quantity to 1 for each ingredient
    INSERT INTO CustomBurger_Ingredients (custom_burger_id, ingredient_id, quantity)
    SELECT @custom_burger_id, i.ingredient_id, 1
    FROM Ingredients i
    JOIN Burger_Ingredients bi ON i.ingredient_id = bi.ingredient_id
    WHERE bi.burger_id = burger_id;

    -- Return the custom burger ID
    SELECT @custom_burger_id AS custom_burger_id;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS GetCustomBurgerIngredients;
DELIMITER //
CREATE PROCEDURE GetCustomBurgerIngredients(IN custom_burger_id INT)
BEGIN
    SELECT i.ingredient_id, i.ingredient_name, i.price, cbi.quantity -- Add quantity field
    FROM Ingredients i
    JOIN CustomBurger_Ingredients cbi ON i.ingredient_id = cbi.ingredient_id
    WHERE cbi.custom_burger_id = custom_burger_id;
END //
DELIMITER ;


-- Drop and recreate the RemoveCustomBurgerIngredient procedure
DROP PROCEDURE IF EXISTS RemoveCustomBurgerIngredient;
DELIMITER //
CREATE PROCEDURE RemoveCustomBurgerIngredient(IN custom_burger_id INT, IN ingredient_id INT)
BEGIN
    -- Check if the ingredient exists in the custom burger and reduce quantity
    UPDATE CustomBurger_Ingredients 
    SET quantity = quantity - 1
    WHERE custom_burger_id = custom_burger_id AND ingredient_id = ingredient_id AND quantity > 1;

    -- If quantity reaches 0, remove the ingredient
    DELETE FROM CustomBurger_Ingredients 
    WHERE custom_burger_id = custom_burger_id AND ingredient_id = ingredient_id AND quantity <= 0;
END //
DELIMITER ;


-- Drop and recreate the AddOrder procedure
DROP PROCEDURE IF EXISTS AddOrder;
DELIMITER //
CREATE PROCEDURE AddOrder(IN customer_id INT, IN custom_burger_id INT, IN total_price DECIMAL(10, 2))
BEGIN
    INSERT INTO Orders (customer_id, custom_burger_id, total_price)
    VALUES (customer_id, custom_burger_id, total_price);
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS ReduceCustomBurgerIngredientQuantity;
DELIMITER //
CREATE PROCEDURE ReduceCustomBurgerIngredientQuantity(IN custom_burger_id_in INT, IN ingredient_id_in INT)
BEGIN
    UPDATE CustomBurger_Ingredients
    SET quantity = IF(quantity > 0, quantity - 1, 0) -- Prevents quantity from going below 0
    WHERE custom_burger_id_in = custom_burger_id AND ingredient_id_in = ingredient_id;
END //
DELIMITER ;




DROP PROCEDURE IF EXISTS IncreaseCustomBurgerIngredientQuantity;
DELIMITER //
CREATE PROCEDURE IncreaseCustomBurgerIngredientQuantity(IN custom_burger_id_in INT, IN ingredient_id_in INT)
BEGIN
    UPDATE CustomBurger_Ingredients
    SET quantity = quantity + 1
    WHERE custom_burger_id_in = custom_burger_id AND ingredient_id_in = ingredient_id;
END //
DELIMITER ;



