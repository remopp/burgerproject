use burger;

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

DROP PROCEDURE IF EXISTS AddOrder;
DELIMITER //
CREATE PROCEDURE AddOrder(IN customerID INT, IN customBurgerID INT, IN totalPrice DECIMAL(10, 2))
BEGIN
    INSERT INTO Orders (customer_id, custom_burger_id, total_price, status) 
    VALUES (customerID, customBurgerID, totalPrice, 'pending');
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

DROP PROCEDURE IF EXISTS GetAllOrders;
DELIMITER //
CREATE PROCEDURE GetAllOrders()
BEGIN
    SELECT o.order_id, c.name AS customer_name, cb.custom_burger_id, cb.custom_name, cb.total_price, i.ingredient_name, cbi.quantity
    FROM Orders o
    JOIN Customers c ON o.customer_id = c.customer_id
    JOIN CustomBurgers cb ON o.custom_burger_id = cb.custom_burger_id
    JOIN CustomBurger_Ingredients cbi ON cb.custom_burger_id = cbi.custom_burger_id
    JOIN Ingredients i ON cbi.ingredient_id = i.ingredient_id
    ORDER BY o.order_time DESC;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS FinalizeCustomBurger;
DELIMITER //
CREATE PROCEDURE FinalizeCustomBurger(
    IN customer_id INT, 
    IN custom_burger_id_param INT, -- Renamed input param to avoid collision
    IN custom_burger_name VARCHAR(255), 
    IN total_price DECIMAL(10, 2)
)
BEGIN
    -- Insert into FinalBurgers table
    INSERT INTO FinalBurgers (customer_id, custom_burger_name, total_price)
    VALUES (customer_id, custom_burger_name, total_price);
    
    -- Get the final burger ID for the newly inserted row
    SET @final_burger_id = LAST_INSERT_ID();
    
    -- Insert ingredients and quantities from CustomBurger_Ingredients into FinalBurger_Ingredients
    INSERT INTO FinalBurger_Ingredients (final_burger_id, ingredient_id, quantity)
    SELECT @final_burger_id, ingredient_id, quantity
    FROM CustomBurger_Ingredients
    WHERE custom_burger_id = custom_burger_id_param;  -- Fix reference to the input parameter
    
    -- Return the final burger ID
    SELECT @final_burger_id AS final_burger_id;
END //
DELIMITER ;



-- Procedure to fetch all finalized burgers and their ingredients
DROP PROCEDURE IF EXISTS GetFinalizedBurgers;
DELIMITER //
CREATE PROCEDURE GetFinalizedBurgers()
BEGIN
    SELECT fb.final_burger_id, fb.custom_burger_name, fb.total_price, fb.order_time, c.name AS customer_name, i.ingredient_name, fbi.quantity, i.price
    FROM FinalBurgers fb
    JOIN Customers c ON fb.customer_id = c.customer_id
    JOIN FinalBurger_Ingredients fbi ON fb.final_burger_id = fbi.final_burger_id
    JOIN Ingredients i ON fbi.ingredient_id = i.ingredient_id
    ORDER BY fb.order_time DESC;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS GetFinalizedBurgers;
DELIMITER //
CREATE PROCEDURE GetFinalizedBurgers()
BEGIN
    SELECT fb.final_burger_id, fb.custom_burger_name, fb.total_price, fb.order_time
    FROM FinalBurgers fb;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS GetFinalizedBurgerIngredients;
DELIMITER //
CREATE PROCEDURE GetFinalizedBurgerIngredients(IN final_burger_id INT)
BEGIN
    SELECT i.ingredient_name, fbi.quantity
    FROM FinalBurger_Ingredients fbi
    JOIN Ingredients i ON fbi.ingredient_id = i.ingredient_id
    WHERE fbi.final_burger_id = final_burger_id;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS GetAllOrders;
DELIMITER //
CREATE PROCEDURE GetAllOrders()
BEGIN
    SELECT 
        o.order_id,
        c.name AS customer_name,
        cb.custom_name AS burger_name,
        SUM(i.price * cbi.quantity) AS total_price,  -- Calculate total price based on quantity
        o.order_time,
        GROUP_CONCAT(CONCAT(i.ingredient_name, ' - Quantity: ', cbi.quantity) SEPARATOR ', ') AS ingredients
    FROM Orders o
    JOIN Customers c ON o.customer_id = c.customer_id
    JOIN CustomBurgers cb ON o.custom_burger_id = cb.custom_burger_id
    JOIN CustomBurger_Ingredients cbi ON cb.custom_burger_id = cbi.custom_burger_id
    JOIN Ingredients i ON cbi.ingredient_id = i.ingredient_id
    WHERE o.status = 'pending'  -- Only show pending orders
    GROUP BY o.order_id, c.name, cb.custom_name, o.order_time
    ORDER BY o.order_time DESC;
END //
DELIMITER ;