const express = require('express');
const router = express.Router();
const src = require('../src/src'); // Make sure this path points to your src.js file

// Route to render the welcome page
router.get('/', (req, res) => {
    res.render('pages/welcome', { title: 'Welcome to Our Burger Project' });
});


router.get('/orders', async (req, res) => {
    try {
        const burgers = await src.getAllBurgers();
        console.log(burgers); // Log the result to verify the data is returned
        res.render('pages/orders', { burgers, title: 'Choose a Burger' });
    } catch (err) {
        console.error(err); // Log any errors
        res.status(500).send('Error fetching burgers');
    }
});

module.exports = router;