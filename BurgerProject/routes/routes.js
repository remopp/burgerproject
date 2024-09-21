const express = require('express');
const router = express.Router();
const src = require('../src/src');

// Render the welcome page
router.get('/', (req, res) => {
    res.render('pages/welcome', { title: 'Welcome to Our Burger Project' });
});

// Fetch and display all predefined burgers
router.get('/orders', async (req, res) => {
    const burgers = await src.getAllBurgers();
    console.log('Fetched burgers:', burgers);
    res.render('pages/orders', { burgers, title: 'Available Burgers' });
});

// Fetch and display the ingredients for a specific predefined burger
router.get('/orders/:id', async (req, res) => {
    const burgerID = req.params.id;
    const ingredients = await src.getBurgerIngredients(burgerID);
    console.log(`Fetched ingredients for burger ${burgerID}:`, ingredients);
    res.render('pages/burgerDetails', { burgerID, ingredients, title: `Burger Details - ${burgerID}` });
});

// Create a custom burger based on a predefined one
router.post('/orders/:id/select', async (req, res) => {
    const sessionID = req.session.id;
    const burgerID = req.params.id;
    const customBurgerID = await src.createCustomBurger(sessionID, burgerID);
    console.log(`Custom burger created with ID: ${customBurgerID}`);
    res.redirect(`/orders/custom/${customBurgerID}`);
});

// Display the details of a custom burger, including ingredients and total price
router.get('/orders/custom/:id', async (req, res) => {
    const customBurgerID = req.params.id;
    const customerID = req.session.customerID || 1; // Assuming a default customerID for testing

    const ingredients = await src.getCustomBurgerIngredients(customBurgerID);
    const totalPrice = ingredients.reduce((sum, ingredient) => sum + (ingredient.price * ingredient.quantity), 0);

    res.render('pages/customBurgerDetails', { 
        customBurgerID,
        customerID,  // Pass customerID to the view
        ingredients,
        totalPrice,
        title: `Customize Your Burger`
    });
});

// Remove an ingredient from a custom burger
router.post('/orders/custom/:id/remove/:ingredientID', async (req, res) => {
    const customBurgerID = req.params.id;
    const ingredientID = req.params.ingredientID;
    console.log(`Removing ingredient ${ingredientID} from custom burger ${customBurgerID}`);
    await src.modifyCustomBurgerIngredientQuantity(customBurgerID, ingredientID, 'decrease');
    res.redirect(`/orders/custom/${customBurgerID}`);
});

// Add an ingredient to a custom burger
router.post('/orders/custom/:id/increase/:ingredientID', async (req, res) => {
    const customBurgerID = req.params.id;
    const ingredientID = req.params.ingredientID;
    console.log(`Adding ingredient ${ingredientID} to custom burger ${customBurgerID}`);
    await src.modifyCustomBurgerIngredientQuantity(customBurgerID, ingredientID, 'increase');
    res.redirect(`/orders/custom/${customBurgerID}`);
});

router.post('/orders/custom/:id/complete', async (req, res) => {
    const customerName = req.body.customerName; // Fetch the customer name from the request
    const customBurgerID = req.params.id;
    const totalPrice = req.body.totalPrice;

    console.log(`Completing order for customer: ${customerName}, burger ID: ${customBurgerID}, total price: ${totalPrice}`);

    try {
        await src.handleOrder(customerName, customBurgerID, totalPrice); // Call the handler to process the order
        res.redirect('/kitchen'); // After the order is completed, redirect to the kitchen view
    } catch (error) {
        console.error('Error completing order:', error);
        res.status(500).send('Failed to complete the order. Please try again.');
    }
});


// Display all pending orders in the kitchen
router.get('/kitchen', async (req, res) => {
    const finalizedOrders = await src.getAllOrders(); // Fetch all orders with details
    console.log('Fetched finalized orders:', finalizedOrders);
    res.render('pages/kitchen', { finalizedOrders, title: 'Kitchen' });
});

router.post('/kitchen/complete/:id', async (req, res) => {
    const orderID = req.params.id;

    try {
        await src.finishOrder(orderID);
        console.log(`Order with ID ${orderID} marked as completed.`);
        res.redirect('/kitchen'); // Reload kitchen page after completion
    } catch (error) {
        console.error('Error finishing order:', error);
        res.status(500).send('Failed to complete the order.');
    }
});




module.exports = router;