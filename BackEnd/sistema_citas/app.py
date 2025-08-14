# app.py
from dotenv import load_dotenv
import os
from flask import Flask, jsonify
from extensions import db, api 
import routes 

load_dotenv()

print("\n--- Depuración de Variables de Entorno ---")
print(f"DB_USER: {os.environ.get('DB_USER')}")
print(f"DB_PASSWORD: {'*' * len(os.environ.get('DB_PASSWORD', ''))}") 
print(f"DB_HOST: {os.environ.get('DB_HOST')}")
print(f"DB_NAME: {os.environ.get('DB_NAME')}")
print(f"DB_PORT: '{os.environ.get('DB_PORT')}'")
print(f"SECRET_KEY: {'*' * len(os.environ.get('SECRET_KEY', ''))}")
print("-------------------------------------------\n")

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = (
    f"postgresql+psycopg2://{os.environ.get('DB_USER')}:"
    f"{os.environ.get('DB_PASSWORD')}@"
    f"{os.environ.get('DB_HOST')}:"
    f"{os.environ.get('DB_PORT')}/"
    f"{os.environ.get('DB_NAME')}"
)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'clave_secreta_default_dev_fallback')

db.init_app(app)
api.init_app(app) 

print(f"SQLALCHEMY_DATABASE_URI: {app.config['SQLALCHEMY_DATABASE_URI']}\n")

@app.route('/')
def index():
    return jsonify({"message": "¡API del Sistema de Citas Médicas funcionando!"}), 200

if __name__ == '__main__':
    with app.app_context():
        try:
            db.create_all()
            print("Tablas de la base de datos creadas/verificadas exitosamente.")
        except Exception as e:
            print(f"Error al crear/verificar tablas de la base de datos: {e}")
            print("Asegúrate de que la base de datos de Neon esté activa y las credenciales sean correctas.")
    app.run(debug=True)