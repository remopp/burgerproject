from flask import Flask, render_template, request, redirect, url_for
import psycopg2

app = Flask(__name__)

DATABASE = {
    'dbname': 'website',
    'user': 'myuser',
    'password': 'mypassword', 
    'host': 'localhost',
    'port': '5432'
}


def get_db_connection():
    conn = psycopg2.connect(**DATABASE)
    return conn

@app.route('/', methods=['GET', 'POST'])
def order():
    burgers = ['Classic Burger (Buns,Patty)', 'Cheeseburger (Buns,Patty,Cheese)', 'Chicken Burger (Buns,Chicken)']

    if request.method == 'POST':
        name = request.form['name']
        burger = request.form['burger']
        ingredients_to_add = request.form['ingredients_add']
        ingredients_to_remove = request.form['ingredients_remove']

        ingredients = f"Add: {ingredients_to_add}, Remove: {ingredients_to_remove}"

        conn = get_db_connection()
        c = conn.cursor()
        c.execute('INSERT INTO orders (name, burger, ingredients) VALUES (%s, %s, %s)', (name, burger, ingredients))
        conn.commit()
        c.close()
        conn.close()

        return redirect(url_for('order'))

    return render_template('order.html', burgers=burgers)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)