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
    const [rows] = await db.query('CALL GetAllBurgers()');
    return rows;
}

// Fetch ingredients for a specific predefined burger
async function getBurgerIngredients(burger_id) {
    await initDB();
    const [rows] = await db.query('CALL GetBurgerIngredients(?)', [burger_id]);
    return rows;
}

// Create a custom burger
async function createCustomBurger(session_id, burger_id) {
    await initDB();
    const result = await db.query('CALL CreateCustomBurger(?, ?)', [session_id, burger_id]);
    return result[0][0].custom_burger_id; // Assuming the procedure returns the new custom burger ID
}

// Fetch ingredients for a specific custom burger
async function getCustomBurgerIngredients(custom_burger_id) {
    await initDB();
    const [rows] = await db.query('CALL GetCustomBurgerIngredients(?)', [custom_burger_id]);
    return rows;
}

// Reduce the quantity of an ingredient in the custom burger or remove it if the quantity is zero
async function removeCustomBurgerIngredient(custom_burger_id, ingredient_id) {
    await initDB();
    await db.query('CALL ReduceCustomBurgerIngredientQuantity(?, ?)', [custom_burger_id, ingredient_id]);
}

// Increase the quantity of an ingredient in the custom burger
async function addCustomBurgerIngredient(custom_burger_id, ingredient_id) {
    await initDB();
    await db.query('CALL IncreaseCustomBurgerIngredientQuantity(?, ?)', [custom_burger_id, ingredient_id]);
}

// Add an order for a custom burger
async function addOrder(customer_id, custom_burger_id, total_price) {
    await initDB();
    await db.query('CALL AddOrder(?, ?, ?)', [customer_id, custom_burger_id, total_price]);
}

module.exports = {
    getAllBurgers,
    getBurgerIngredients,
    createCustomBurger,
    getCustomBurgerIngredients,
    removeCustomBurgerIngredient,
    addCustomBurgerIngredient, // Updated function for adding quantity
    addOrder
};
