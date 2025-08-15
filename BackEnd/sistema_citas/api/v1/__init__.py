# api/v1/__init__.py
from flask import Blueprint
from flask_restful import Api

# Importa las clases de recursos usando importaciones relativas
# CAMBIO IMPORTANTE AQUÍ: Se usa el punto (.) para indicar importación relativa dentro del paquete.
from .resources.paciente import PacienteResource
from .resources.medico import MedicoResource
from .resources.consultorio import ConsultorioResource
from .resources.cita import CitaResource

# Crea un Blueprint para la versión 1 de la API.
# Esto permite modularizar la aplicación.
api_bp_v1 = Blueprint('api_v1', __name__, url_prefix='/api/v1')

# Inicializa Flask-RESTful con el Blueprint.
api_v1 = Api(api_bp_v1)

# Registra los recursos con sus respectivas rutas en la API v1.
# Por ejemplo, /api/v1/pacientes o /api/v1/pacientes/<int:paciente_id>
api_v1.add_resource(PacienteResource, "/pacientes", "/pacientes/<int:paciente_id>")
api_v1.add_resource(MedicoResource, "/medicos", "/medicos/<int:medico_id>")
api_v1.add_resource(ConsultorioResource, "/consultorios", "/consultorios/<int:consultorio_id>")
api_v1.add_resource(CitaResource, "/citas", "/citas/<int:cita_id>")
