const express = require('express');
const session = require('express-session');
const indexRoutes = require('./routes/routes.js'); // Your routes file

const app = express();
const port = 1339;

// Use session middleware
app.use(session({
    secret: 'your-secret-key', // Change this to a secure secret key
    resave: false, // Prevents resaving session if nothing changed
    saveUninitialized: true, // Save new sessions that are unmodified
    cookie: { secure: false } // Set to true if using HTTPS
}));

app.use(express.static('public'));
app.set('view engine', 'ejs');
app.use(express.urlencoded({ extended: true }));

// Routes
app.use('/', indexRoutes);

app.listen(port, () => {
    console.log(`Server is listening on port: ${port}`);
});
