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

// Adjust the quantity of an ingredient in the custom burger (Increase or Decrease)
async function modifyCustomBurgerIngredientQuantity(custom_burger_id, ingredient_id, action) {
    await initDB();
    if (action === 'increase') {
        await db.query('CALL IncreaseCustomBurgerIngredientQuantity(?, ?)', [custom_burger_id, ingredient_id]);
    } else if (action === 'decrease') {
        await db.query('CALL ReduceCustomBurgerIngredientQuantity(?, ?)', [custom_burger_id, ingredient_id]);
    }
}

// Add an order
async function addOrder(customer_id, custom_burger_id, total_price) {
    await initDB();
    await db.query('CALL AddOrder(?, ?, ?)', [customer_id, custom_burger_id, total_price]);
}

// Fetch all orders
async function getAllOrders() {
    await initDB();
    const [rows] = await db.query('CALL GetAllOrders()');
    return rows;
}

// Fetch customer by name
async function getCustomerByName(name) {
    await initDB();
    const result = await db.query('SELECT * FROM Customers WHERE name = ?', [name]);
    const rows = Array.isArray(result) ? result : []; // Ensure rows is always an array
    return rows.length > 0 ? rows[0] : null; // Check if rows exist, return the customer or null if not found
}

// Create a new customer with a given name
async function createCustomer(name) {
    await initDB();
    const result = await db.query('INSERT INTO Customers (name) VALUES (?)', [name]);
    return result.insertId; // Return the customer ID
}

async function handleOrder(customerName, customBurgerID, totalPrice) {
    await initDB();

    let customer = await getCustomerByName(customerName); // Fetch customer by name
    if (!customer) {
        const customerID = await createCustomer(customerName); // Create customer if not found
        customer = { customer_id: customerID };
    }

    // Now, add the order for the found or newly created customer
    await addOrder(customer.customer_id, customBurgerID, totalPrice);
}

async function finishOrder(orderID) {
    await initDB();
    try {
        const result = await db.query('UPDATE Orders SET status = "completed" WHERE order_id = ?', [orderID]);
        console.log(`Order with ID ${orderID} marked as completed. Affected rows: ${result.affectedRows}`);
    } catch (error) {
        console.error(`Error completing order with ID ${orderID}:`, error);
    }
}



module.exports = {
    getAllBurgers,
    getBurgerIngredients,
    createCustomBurger,
    getCustomBurgerIngredients,
    modifyCustomBurgerIngredientQuantity,
    addOrder,
    getAllOrders,
    getCustomerByName,
    createCustomer,
    handleOrder,
    finishOrder
};