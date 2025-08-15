# api/v1/parsers.py
from flask_restful import reqparse

# --- Parsers para validar y obtener datos de las peticiones ---

# Paciente Parser
paciente_parser = reqparse.RequestParser()
paciente_parser.add_argument("nombre", type=str, required=True, help="Nombre es obligatorio", location='json')
paciente_parser.add_argument("apellido", type=str, required=True, help="Apellido es obligatorio", location='json')
paciente_parser.add_argument("fecha_nacimiento", type=str, required=True, help="Fecha de nacimiento es obligatoria (YYYY-MM-DD)", location='json')
paciente_parser.add_argument("email", type=str, required=True, help="Email es obligatorio y único", location='json')

# Medico Parser
medico_parser = reqparse.RequestParser()
medico_parser.add_argument("nombre", type=str, required=True, help="Nombre es obligatorio", location='json')
medico_parser.add_argument("apellido", type=str, required=True, help="Apellido es obligatorio", location='json')
medico_parser.add_argument("especialidad", type=str, required=True, help="Especialidad es obligatoria", location='json')

# Consultorio Parser
consultorio_parser = reqparse.RequestParser()
consultorio_parser.add_argument("numero", type=str, required=True, help="Número de consultorio es obligatorio y único", location='json')
consultorio_parser.add_argument("piso", type=int, required=True, help="Piso es obligatorio", location='json')

# Cita Parser
cita_parser = reqparse.RequestParser()
cita_parser.add_argument("paciente_id", type=int, required=True, help="ID del paciente es obligatorio", location='json')
cita_parser.add_argument("medico_id", type=int, required=True, help="ID del médico es obligatorio", location='json')
cita_parser.add_argument("consultorio_id", type=int, required=True, help="ID del consultorio es obligatorio", location='json')
cita_parser.add_argument("fecha", type=str, required=True, help="Fecha de la cita es obligatoria (YYYY-MM-DD)", location='json')
cita_parser.add_argument("hora", type=str, required=True, help="Hora de la cita es obligatoria (HH:MM:SS)", location='json')
