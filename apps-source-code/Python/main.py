from flask import Flask, request, jsonify
import json
import psycopg2

app = Flask(__name__)

def store_in_postgres(sorted_numbers):
    try:
        postgres_conn = psycopg2.connect(
            host="postgres",
            database="postgres",
            user="postgres",
            password="postgres",
            port="5432"
        )

        postgres_cursor = postgres_conn.cursor()

        postgres_cursor.execute("INSERT INTO numbers (sorted_numbers) VALUES (%s)", (sorted_numbers,))

        postgres_conn.commit()
        postgres_cursor.close()
        postgres_conn.close()

    except Exception as e:
        print("Error storing in PostgreSQL:", e)

@app.route('/sort', methods=['POST'])
def sort_numbers():
    try:
        data = request.json
        sorted_numbers = sorted(data['numbers'])
        print(sorted_numbers)
        store_in_postgres(sorted_numbers)
        return jsonify({"sorted_numbers":sorted_numbers})
    
    except Exception as e:
        print(e)
        return jsonify(error='Internal Server Error'), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
