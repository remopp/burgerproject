const express = require('express');
const router = express.Router();
const src = require('../src/src'); // Ensure this points to the correct path for src.js

// Route to render the welcome page
router.get('/', (req, res) => {
    res.render('pages/welcome', { title: 'Welcome to Our Burger Project' });
});

// Route to list all burgers
router.get('/orders', async (req, res) => {
    try {
        const burgers = await src.getAllBurgers(); // Fetch all burgers
        res.render('pages/orders', { burgers, title: 'Available Burgers' }); // Pass burgers to the EJS view
    } catch (err) {
        console.error('Error fetching burgers:', err);
        res.status(500).send('Error fetching burgers');
    }
});

// Route to display a specific burger's ingredients
router.get('/orders/:id', async (req, res) => {
    const burgerID = req.params.id;
    try {
        const ingredients = await src.getBurgerIngredients(burgerID);
        console.log("Fetched ingredients after removal:", ingredients); // Log the result here
        res.render('pages/burgerDetails', {
            burgerID,
            ingredients,
            title: `Burger Details - ${burgerID}`
        });
    } catch (err) {
        console.error(err); // Log any errors
        res.status(500).send('Error fetching burger ingredients');
    }
});

// Route to remove an ingredient from a burger
router.post('/orders/:id/remove/:ingredientID', async (req, res) => {
    const burgerID = req.params.id;
    const ingredientID = req.params.ingredientID;
    try {
        await src.removeIngredient(burgerID, ingredientID); // Calls the removal function
        res.redirect(`/orders/${burgerID}`); // Redirect back to the burger details page
    } catch (err) {
        console.error('Error removing ingredient:', err);
        res.status(500).send('Error removing ingredient');
    }
});

// Route to add a custom burger order to the orders table
router.post('/orders/:id/complete', async (req, res) => {
    const customerID = req.body.customerID;
    const burgerID = req.params.id;
    const totalPrice = req.body.totalPrice;
    try {
        await src.addOrder(customerID, burgerID, totalPrice);
        res.redirect('/orders');
    } catch (err) {
        res.status(500).send('Error adding order');
    }
});

module.exports = router;
