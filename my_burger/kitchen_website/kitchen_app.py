from flask import Flask, render_template, request, redirect, url_for
import psycopg2

app = Flask(__name__)

DATABASE = {
    'dbname': 'website',
    'user': 'postgres',
    'password': '2c75533f72c9',
    'host': 'db', 
    'port': '5432'
}

def get_db_connection():
    conn = psycopg2.connect(**DATABASE)
    return conn

def init_db():
    conn = get_db_connection()
    c = conn.cursor()

    c.execute('''
        SELECT EXISTS (
            SELECT 1 
            FROM information_schema.tables 
            WHERE table_name = 'orders'
        );
    ''')
    table_exists = c.fetchone()[0]

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

    c.close()
    conn.close()

@app.route('/')
def kitchen():
    conn = get_db_connection()
    c = conn.cursor()
    c.execute('SELECT * FROM orders')
    orders = c.fetchall()
    c.close()
    conn.close()
    return render_template('kitchen.html', orders=orders)

@app.route('/delete_order/<int:order_id>', methods=['POST'])
def delete_order(order_id):
    conn = get_db_connection()
    c = conn.cursor()
    c.execute('DELETE FROM orders WHERE id = %s', (order_id,))
    conn.commit()
    c.close()
    conn.close()
    return redirect(url_for('kitchen'))

if __name__ == '__main__':
    init_db() 
    app.run(host='0.0.0.0', port=5001, debug=True)
