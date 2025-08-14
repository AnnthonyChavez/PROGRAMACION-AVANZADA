import requests

BASE = "http://127.0.0.1:5000/api"

# Crear paciente
pac = requests.post(f"{BASE}/pacientes", json={
    "nombre": "Mario",
    "apellido": "López",
    "fecha_nacimiento": "1980-02-15",
    "email": "mario.lopez@mail.com"
}).json()
print("Paciente creado:", pac)

# Crear médico
med = requests.post(f"{BASE}/medicos", json={
    "nombre": "Ana",
    "apellido": "Martínez",
    "especialidad": "Cardiología"
}).json()
print("Médico creado:", med)

# Crear consultorio
cons = requests.post(f"{BASE}/consultorios", json={
    "numero": "101",
    "piso": 1
}).json()
print("Consultorio creado:", cons)

# Crear cita
cita = requests.post(f"{BASE}/citas", json={
    "paciente_id": pac["paciente"]["id"],
    "medico_id": med["medico"]["id"],
    "consultorio_id": cons["consultorio"]["id"],
    "fecha": "2025-12-01",
    "hora": "10:00:00"
}).json()
print("Cita creada:", cita)
