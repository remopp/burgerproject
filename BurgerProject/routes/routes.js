const express = require('express');
const router = express.Router();
const src = require('../src/src');

router.get('/', (req, res) => {
    res.render('pages/welcome', { title: 'Welcome to Our Burger Project' });
});

router.get('/orders', async (req, res) => {
    const burgers = await src.getAllBurgers();
    console.log('Fetched burgers:', burgers);
    res.render('pages/orders', { burgers, title: 'Available Burgers' });
});

router.get('/orders/:id', async (req, res) => {
    const burgerID = req.params.id;
    const ingredients = await src.getBurgerIngredients(burgerID);
    console.log(`Fetched ingredients for burger ${burgerID}:`, ingredients);
    res.render('pages/burgerDetails', { burgerID, ingredients, title: `Burger Details - ${burgerID}` });
});

router.post('/orders/:id/select', async (req, res) => {
    const sessionID = req.session.id;
    const burgerID = req.params.id;
    const customBurgerID = await src.createCustomBurger(sessionID, burgerID);
    console.log(`Custom burger created with ID: ${customBurgerID}`);
    res.redirect(`/orders/custom/${customBurgerID}`);
});

router.get('/orders/custom/:id', async (req, res) => {
    const customBurgerID = req.params.id;
    const ingredients = await src.getCustomBurgerIngredients(customBurgerID);
    const totalPrice = ingredients.reduce((sum, ingredient) => sum + (ingredient.price * ingredient.quantity), 0);
    res.render('pages/customBurgerDetails', { customBurgerID, ingredients, totalPrice, title: `Customize Your Burger` });
});

router.post('/orders/custom/:id/remove/:ingredientID', async (req, res) => {
    const customBurgerID = req.params.id;
    const ingredientID = req.params.ingredientID;
    console.log(`Removing ingredient ${ingredientID} from custom burger ${customBurgerID}`);
    await src.removeCustomBurgerIngredient(customBurgerID, ingredientID);
    res.redirect(`/orders/custom/${customBurgerID}`);
});

router.post('/orders/custom/:id/complete', async (req, res) => {
    const customerID = req.body.customerID;
    const customBurgerID = req.params.id;
    const totalPrice = req.body.totalPrice;
    console.log(`Completing order for customer ${customerID} with custom burger ${customBurgerID} at total price ${totalPrice}`);
    await src.addOrder(customerID, customBurgerID, totalPrice);
    res.redirect('/orders');
});

router.post('/orders/custom/:id/increase/:ingredientID', async (req, res) => {
    const customBurgerID = req.params.id;
    const ingredientID = req.params.ingredientID;
    console.log(`Adding ingredient ${ingredientID} to custom burger ${customBurgerID}`);
    await src.addCustomBurgerIngredient(customBurgerID, ingredientID);
    res.redirect(`/orders/custom/${customBurgerID}`);
});

module.exports = router;
