const express = require('express');
const session = require('express-session');
const routes = require('./routes'); // Ensure correct path to routes.js

const app = express();
const port = 1339;

// Set the view engine to EJS
app.set('view engine', 'ejs');

// Set up middleware for handling sessions
app.use(session({
    secret: 'your-secret-key', 
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false } // Use true if using HTTPS
}));

// Serve static files (like CSS, images)
app.use(express.static('public'));

// Parse URL-encoded bodies (for form submissions)
app.use(express.urlencoded({ extended: true }));

// Register routes
app.use('/', routes);  // This will handle all routes from routes.js

// Start the server
app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
