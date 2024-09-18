USE burger;

LOAD DATA LOCAL INFILE 'ingredients_table.csv'
INTO TABLE Ingredients
FIELDS TERMINATED BY ',' ENCLOSED BY "'" LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'burgers_table.csv'
INTO TABLE Burgers
FIELDS TERMINATED BY ',' ENCLOSED BY "'" LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'burger_ingredients_table.csv'
INTO TABLE Burger_Ingredients
FIELDS TERMINATED BY ',' ENCLOSED BY "'" LINES TERMINATED BY '\n'
IGNORE 1 LINES;