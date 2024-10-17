const express = require('express');
const router = express.Router();
const src = require('./src/src');

router.get('/kitchen', async (req, res) => {
    const finalizedOrders = await src.getAllOrders();
    res.render('pages/kitchen', { finalizedOrders, title: 'Kitchen' });
});

router.post('/kitchen/complete/:id', async (req, res) => {
    const orderID = req.params.id;
    await src.finishOrder(orderID);
    console.log(`Order with ID ${orderID} marked as completed.`);
    res.redirect('/kitchen');
});

module.exports = router;
