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


DELIMITER //

CREATE PROCEDURE GetBurgerIngredients(IN selected_burger_id INT)
BEGIN
    SELECT i.ingredient_id, i.ingredient_name, i.price
    FROM Ingredients i
    JOIN Burger_Ingredients bi ON i.ingredient_id = bi.ingredient_id
    WHERE bi.burger_id = selected_burger_id;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE RemoveBurgerIngredient(IN p_burger_id INT, IN p_ingredient_id INT)
BEGIN
    DELETE FROM Burger_Ingredients 
    WHERE burger_id = p_burger_id AND ingredient_id = p_ingredient_id;
END //

DELIMITER ;



DELIMITER //

CREATE PROCEDURE AddOrder(IN customer_id INT, IN burger_id INT, IN total_price DECIMAL(10, 2))
BEGIN
    INSERT INTO Orders (customer_id, burger_id, total_price)
    VALUES (customer_id, burger_id, total_price);
END //

DELIMITER ;