"""this is the code for the order website"""
from flask import Flask, render_template, request, redirect, url_for
import psycopg2
import os

app = Flask(__name__)

# Database configuration for local PostgreSQL (with docker)
DATABASE = {
    'dbname': 'website',
    'user': 'postgres',
    'password': '2c75533f72c9',
    'host': 'db', 
    'port': '5432'
}

# # Database configuration for local PostgreSQL (without docker)
# DATABASE = {
#     'dbname': 'website',
#     'user': 'myuser',
#     'password': 'mypassword',
#     'host': 'localhost',
#     'port': '5432'
# }

# DATABASE = {
#     'dbname': 'website',
#     'user': os.getenv('DATABASE_USER', 'myuser'),
#     'password': os.getenv('DATABASE_PASSWORD', 'mypassword'),
#     'host': 'localhost',
#     'port': '5432'
# }


def get_db_connection():
    """
    Establish a connection to the PostgreSQL database using psycopg2.
    
    Retrieves the database host from environment variables if available, otherwise defaults to 'localhost'.
    
    Returns:
        conn: A connection object to interact with the database.
    """
    db_host = os.getenv('DATABASE_HOST', 'localhost') # Get the database host from environment variable or use localhost
    conn = psycopg2.connect(
        dbname=DATABASE['dbname'],
        user=DATABASE['user'],
        password=DATABASE['password'],
        host=db_host,
        port=DATABASE['port']
    )
    return conn

@app.route('/', methods=['GET', 'POST'])
# This decorator maps the root URL ('/') to the 'order' function.
# It specifies that the route accepts both GET and POST HTTP methods
def order():
    """
    Handles the ordering of burgers. Renders the order form and processes form submissions.
    Methods:
        GET: Renders the order form.
        POST: Processes the submitted order form, saves the order details to the database, and redirects the user.
    Returns:
        On GET: Renders the order form with a list of available burgers.
        On POST: Saves the order to the database and redirects to the same page.
    """
    
    # List of available burgers to choose from
    burgers = ['Classic Burger (Bans,Patty)', 'Cheeseburger (Buns,Patty,Cheese)', 'Chicken Burger (Buns,Chicken)']

    if request.method == 'POST':
        # Get form data from the user
        name = request.form['name'] # Customer's name
        burger = request.form['burger'] # Selected burger
        ingredients_to_add = request.form['ingredients_add']  # Ingredients to add
        ingredients_to_remove = request.form['ingredients_remove'] # Ingredients to remove

        ingredients = f"Add: {ingredients_to_add}, Remove: {ingredients_to_remove}"

        # Establish database connection and insert order details into 'orders' table
        conn = get_db_connection()
        c = conn.cursor()
        c.execute('INSERT INTO orders (name, burger, ingredients) VALUES (%s, %s, %s)', (name, burger, ingredients))
        conn.commit()
        c.close()
        conn.close()

        # Redirect to the same page to refresh the form
        return redirect(url_for('order'))
    
    # Render the order form with the available burgers
    return render_template('order.html', burgers=burgers)

if __name__ == '__main__':
    # runs website
    app.run(host='0.0.0.0', port=5000, debug=True, use_reloader=False)
