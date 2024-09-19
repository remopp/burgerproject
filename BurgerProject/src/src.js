"use strict";

const mysql = require("promise-mysql");
const config = require("../config/db/config.json");

let db;

async function initDB() {
    if (!db) {
        db = await mysql.createPool({
            host: config.host,
            user: config.user,
            password: config.password,
            database: config.database,
            connectionLimit: 10,
        });
    }
}

// Fetch all burgers
async function getAllBurgers() {
    await initDB();
    const rows = await db.query('CALL GetAllBurgers()');
    return rows[0]; // Return the first result set from the stored procedure
}


// Fetch ingredients for a specific burger
async function getBurgerIngredients(burger_id) {
    await initDB();
    const [rows] = await db.query('CALL GetBurgerIngredients(?)', [burger_id]);
    return rows; // Ensure this returns the actual data
}

// Remove an ingredient from a burger
async function removeIngredient(burgerID, ingredientID) {
    console.log(`Attempting to remove ingredient ${ingredientID} from burger ${burgerID}`); // Log this
    await initDB();
    await db.query('CALL RemoveBurgerIngredient(?, ?)', [burgerID, ingredientID]);
}

// Add a custom burger order
async function addOrder(customer_id, burger_id, total_price) {
    await initDB();
    await db.query('CALL AddCustomBurgerOrder(?, ?, ?)', [customer_id, burger_id, total_price]);
}

module.exports = {
    getAllBurgers,
    getBurgerIngredients,
    removeIngredient,
    addOrder
};
