const express = require('express');
const router = express.Router();

// Route to render the welcome page
router.get('/', (req, res) => {
    res.render('pages/welcome', { title: 'Welcome to Our Burger Project' });
});


module.exports = router;