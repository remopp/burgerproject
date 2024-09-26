const express = require('express');
const session = require('express-session');
const indexRoutes = require('./routes/routes.js');
const kitchenRoutes = require('./routes/kitchen_routes');

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

app.use('/', indexRoutes);

app.use('/kitchen', kitchenRoutes);

app.use((req, res, next) => {
    res.status(404).render('pages/404', { title: 'Page Not Found' });
});

app.use((err, req, res, next) => {
    console.error('Error:', err);
    res.status(500).render('pages/500', { title: 'Server Error' });
});

app.listen(port, () => {
    console.log(`Server is running and listening on port: ${port}`);
});
