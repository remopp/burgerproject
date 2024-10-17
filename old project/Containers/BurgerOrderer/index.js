const express = require('express');
const session = require('express-session');
const routes = require('./routes');

const app = express();
const port = 1339;

app.set('view engine', 'ejs');

app.use(session({
    secret: 'your-secret-key', 
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false } 
}));

app.use(express.static('public'));


app.use(express.urlencoded({ extended: true }));

app.use('/', routes);  

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
