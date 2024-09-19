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

async function getAllBurgers() {
    await initDB();
    const rows = await db.query('CALL GetAllBurgers()');
    return rows[0];
}

module.exports = {
    getAllBurgers
};
