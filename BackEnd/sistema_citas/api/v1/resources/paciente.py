# api/v1/resources/paciente.py
import re
from datetime import datetime, date
from flask_restful import Resource
from extensions import db
from models import Paciente
from api.v1.parsers import paciente_parser

class PacienteResource(Resource):
    def get(self, paciente_id=None):
        """
        Maneja las peticiones GET para obtener uno o todos los pacientes.
        Si se proporciona paciente_id, devuelve un paciente específico.
        De lo contrario, devuelve una lista de todos los pacientes.
        """
        if paciente_id:
            paciente = Paciente.query.get(paciente_id)
            if not paciente:
                return {"message": "Paciente no encontrado"}, 404
            return paciente.to_dict(), 200 # Se devuelve el diccionario y el código de estado explícito
        
        pacientes = Paciente.query.all()
        return [p.to_dict() for p in pacientes], 200 # Se devuelve una lista de diccionarios y el código de estado

    def post(self):
        """
        Maneja las peticiones POST para crear un nuevo paciente.
        Incluye validaciones para la fecha de nacimiento (formato, no futuro/pasado excesivo)
        y el formato del email, además de unicidad del email.
        """
        args = paciente_parser.parse_args()
        nombre = args['nombre']
        apellido = args['apellido']
        fecha_nacimiento_str = args['fecha_nacimiento']
        email = args['email']

        # Validación de formato y rango de fecha de nacimiento
        try:
            fecha_nacimiento = datetime.strptime(fecha_nacimiento_str, '%Y-%m-%d').date()
            if fecha_nacimiento >= date.today():
                return {"message": "La fecha de nacimiento no puede ser en el futuro ni hoy."}, 400
            if fecha_nacimiento.year < 1900:
                return {"message": "La fecha de nacimiento no puede ser anterior al 1 de enero de 1900."}, 400
        except ValueError:
            return {"message": "Formato de fecha de nacimiento inválido. Usa YYYY-MM-DD."}, 400

        # Validación de formato de email con expresión regular
        if not re.match(r"[^@]+@[^@]+\.[^@]+", email):
            return {"message": "Formato de email inválido."}, 400

        try:
            # Verificar si el email ya está registrado
            existing_paciente = Paciente.query.filter_by(email=email).first()
            if existing_paciente:
                return {"message": "El email ya está registrado"}, 409 # Conflict

            nuevo_paciente = Paciente(
                nombre=nombre,
                apellido=apellido,
                fecha_nacimiento=fecha_nacimiento,
                email=email
            )
            db.session.add(nuevo_paciente)
            db.session.commit()
            return {"message": "Paciente agregado correctamente", "paciente": nuevo_paciente.to_dict()}, 201 # Created
        except Exception as e:
            db.session.rollback()
            print(f"Error al crear paciente: {e}")
            return {"message": "Error interno del servidor al crear paciente"}, 500 # Internal Server Error

    def put(self, paciente_id):
        """
        Maneja las peticiones PUT para actualizar un paciente existente.
        Incluye las mismas validaciones que POST para la fecha de nacimiento y el email,
        además de verificar unicidad del email si cambia.
        """
        args = paciente_parser.parse_args()
        paciente = Paciente.query.get(paciente_id)
        if not paciente:
            return {"message": "Paciente no encontrado"}, 404

        nombre = args['nombre']
        apellido = args['apellido']
        fecha_nacimiento_str = args['fecha_nacimiento']
        email = args['email']

        # Validación de formato y rango de fecha de nacimiento
        try:
            fecha_nacimiento = datetime.strptime(fecha_nacimiento_str, '%Y-%m-%d').date()
            if fecha_nacimiento >= date.today():
                return {"message": "La fecha de nacimiento no puede ser en el futuro ni hoy."}, 400
            if fecha_nacimiento.year < 1900:
                return {"message": "La fecha de nacimiento no puede ser anterior al 1 de enero de 1900."}, 400
        except ValueError:
            return {"message": "Formato de fecha de nacimiento inválido. Usa YYYY-MM-DD."}, 400

        # Validación de formato de email
        if not re.match(r"[^@]+@[^@]+\.[^@]+", email):
            return {"message": "Formato de email inválido."}, 400

        try:
            # Verificar unicidad del email si se ha cambiado
            if email != paciente.email:
                existing_paciente = Paciente.query.filter_by(email=email).first()
                if existing_paciente and existing_paciente.id != paciente_id:
                    return {"message": "El email ya está registrado para otro paciente"}, 409

            paciente.nombre = nombre
            paciente.apellido = apellido
            paciente.fecha_nacimiento = fecha_nacimiento
            paciente.email = email
            db.session.commit()
            return {"message": "Paciente actualizado correctamente", "paciente": paciente.to_dict()}, 200
        except Exception as e:
            db.session.rollback()
            print(f"Error al actualizar paciente: {e}")
            return {"message": "Error interno del servidor al actualizar paciente"}, 500

    def delete(self, paciente_id):
        """
        Maneja las peticiones DELETE para eliminar un paciente.
        Impide la eliminación si el paciente tiene citas asociadas.
        """
        paciente = Paciente.query.get(paciente_id)
        if not paciente:
            return {"message": "Paciente no encontrado"}, 404
        
        try:
            # Restricción: No se puede eliminar si tiene citas asociadas
            if paciente.citas: # 'citas' es la relación que definimos en models.py
                return {"message": "No se puede eliminar el paciente porque tiene citas asociadas. Elimina las citas primero."}, 409

            db.session.delete(paciente)
            db.session.commit()
            return {"message": "Paciente eliminado correctamente"}, 204 # No Content
        except Exception as e:
            db.session.rollback()
            print(f"Error al eliminar paciente: {e}")
            return {"message": "Error interno del servidor al eliminar paciente"}, 500
