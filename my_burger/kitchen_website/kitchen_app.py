from flask import Flask, render_template, request, redirect, url_for
import psycopg2

app = Flask(__name__)

# Database configuration details
DATABASE = {
    'dbname': 'website',
    'user': 'postgres',
    'password': '2c75533f72c9',
    'host': 'db',  # Use 'db' here instead of 'localhost'
    'port': '5432'
}

# Function to establish a connection to the database
def get_db_connection():
    """
    Establish a connection to the PostgreSQL database using the provided configuration.
    
    Returns:
        connection: A psycopg2 connection object to interact with the database.
    """
    conn = psycopg2.connect(**DATABASE)
    return conn

# Function to initialize the database if it does not exist
def init_db():
    """
    Initialize the database by creating the 'orders' table if it does not exist.
    This function ensures that the necessary database structure is set up before the application runs.
    """
    conn = get_db_connection()
    c = conn.cursor()

    # Check if the 'orders' table exists
    c.execute('''
        SELECT EXISTS (
            SELECT 1 
            FROM information_schema.tables 
            WHERE table_name = 'orders'
        );
    ''')
    table_exists = c.fetchone()[0]

    # Create the 'orders' table if it does not exist
    if not table_exists:
        c.execute('''
            CREATE TABLE orders (
                id SERIAL PRIMARY KEY,
                name TEXT,
                burger TEXT,
                ingredients TEXT
            );
        ''')
        conn.commit()

    # Close the cursor and the connection
    c.close()
    conn.close()

# Route to display the kitchen view
@app.route('/')
def kitchen():
    """
    Render the kitchen view, displaying all current orders.
    
    Returns:
        str: Rendered HTML template for the kitchen view, including the list of orders.
    """
    conn = get_db_connection()
    c = conn.cursor()
    # Fetch all orders from the 'orders' table
    c.execute('SELECT * FROM orders')
    orders = c.fetchall()
    # Close the cursor and the connection
    c.close()
    conn.close()
    return render_template('kitchen.html', orders=orders)

# Route to delete an order
@app.route('/delete_order/<int:order_id>', methods=['POST'])
def delete_order(order_id):
    """
    Delete an order from the database based on the provided order ID.
    
    Args:
        order_id (int): The ID of the order to be deleted.
    
    Returns:
        Response: A redirect response to the kitchen view after deleting the order.
    """
    conn = get_db_connection()
    c = conn.cursor()
    # Delete the order with the given order ID
    c.execute('DELETE FROM orders WHERE id = %s', (order_id,))
    conn.commit()
    # Close the cursor and the connection
    c.close()
    conn.close()
    return redirect(url_for('kitchen'))

if __name__ == '__main__':
    # Initialize the database
    init_db() 
    # Run the application
    app.run(host='0.0.0.0', port=5001, debug=True)
