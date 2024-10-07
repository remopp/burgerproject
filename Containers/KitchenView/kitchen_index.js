const express = require('express');
const session = require('express-session');
const kitchenRoutes = require('./kitchen_routes.js');

const app = express();
const port = 1339;

app.use(session({
    secret: 'your-secret-key',
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false }
}));

app.use(express.static('public'));  

app.set('view engine', 'ejs');

app.use(express.urlencoded({ extended: true }));

app.use('/', kitchenRoutes);

app.listen(port, () => {
    console.log(`Kitchen server is running and listening on port: ${port}`);
});
