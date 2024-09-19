DELIMITER //

CREATE PROCEDURE GetAllBurgers()
BEGIN
    SELECT b.burger_id, b.burger_name, SUM(i.price) AS burger_price
    FROM Burgers b
    JOIN Burger_Ingredients bi ON b.burger_id = bi.burger_id
    JOIN Ingredients i ON bi.ingredient_id = i.ingredient_id
    GROUP BY b.burger_id;
END //

DELIMITER ;