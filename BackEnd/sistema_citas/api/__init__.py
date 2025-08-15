# api/v1/resources/cita.py
from datetime import datetime, date, time
from flask_restful import Resource
from extensions import db
from models import Cita, Paciente, Medico, Consultorio
from api.v1.parsers import cita_parser

class CitaResource(Resource):
    def get(self, cita_id=None):
        """
        Maneja las peticiones GET para obtener una o todas las citas.
        """
        if cita_id:
            cita = Cita.query.get(cita_id)
            if not cita:
                return {"message": "Cita no encontrada"}, 404
            return cita.to_dict(), 200
        
        citas = Cita.query.all()
        return [c.to_dict() for c in citas], 200

    def post(self):
        """
        Maneja las peticiones POST para crear una nueva cita.
        Incluye validaciones estrictas para fechas, horas y disponibilidad.
        """
        args = cita_parser.parse_args()
        paciente_id = args['paciente_id']
        medico_id = args['medico_id']
        consultorio_id = args['consultorio_id']
        fecha_str = args['fecha']
        hora_str = args['hora']

        # Validación de formato de fecha y hora
        try:
            fecha_cita = datetime.strptime(fecha_str, '%Y-%m-%d').date()
            hora_cita = datetime.strptime(hora_str, '%H:%M:%S').time()
        except ValueError:
            return {"message": "Formato de fecha u hora inválido. Usa YYYY-MM-DD y HH:MM:SS."}, 400

        # Validación: No se puede agendar una cita en el pasado
        if fecha_cita < date.today() or \
           (fecha_cita == date.today() and hora_cita < datetime.now().time()):
            return {"message": "No se puede agendar una cita en el pasado."}, 400

        # Validación: Horario de atención (e.g., de 8 AM a 6 PM)
        # Puedes ajustar este rango según tus necesidades de negocio
        if not (time(8, 0, 0) <= hora_cita <= time(18, 0, 0)):
            return {"message": "La hora de la cita debe estar entre las 08:00:00 y las 18:00:00."}, 400

        # Validación de existencia de claves foráneas
        paciente = Paciente.query.get(paciente_id)
        if not paciente:
            return {"message": f"Paciente con ID {paciente_id} no encontrado."}, 400
        medico = Medico.query.get(medico_id)
        if not medico:
            return {"message": f"Médico con ID {medico_id} no encontrado."}, 400
        consultorio = Consultorio.query.get(consultorio_id)
        if not consultorio:
            return {"message": f"Consultorio con ID {consultorio_id} no encontrado."}, 400

        # Validación de disponibilidad: Médico ya tiene una cita a esa fecha y hora
        existing_cita_medico = Cita.query.filter_by(
            medico_id=medico_id,
            fecha=fecha_cita,
            hora=hora_cita
        ).first()
        if existing_cita_medico:
            return {"message": "El médico ya tiene una cita agendada a esa fecha y hora."}, 409

        # Validación de disponibilidad: Consultorio ya está ocupado a esa fecha y hora
        existing_cita_consultorio = Cita.query.filter_by(
            consultorio_id=consultorio_id,
            fecha=fecha_cita,
            hora=hora_cita
        ).first()
        if existing_cita_consultorio:
            return {"message": "El consultorio ya está ocupado a esa fecha y hora."}, 409

        try:
            nueva_cita = Cita(
                paciente_id=paciente_id,
                medico_id=medico_id,
                consultorio_id=consultorio_id,
                fecha=fecha_cita,
                hora=hora_cita
            )
            db.session.add(nueva_cita)
            db.session.commit()
            return {"message": "Cita agregada correctamente", "cita": nueva_cita.to_dict()}, 201
        except Exception as e:
            db.session.rollback()
            print(f"Error al crear cita: {e}")
            return {"message": "Error interno del servidor al crear cita"}, 500
    
    def put(self, cita_id):
        """
        Maneja las peticiones PUT para actualizar una cita existente.
        Incluye las mismas validaciones que POST, pero excluyendo la cita actual
        en las comprobaciones de disponibilidad.
        """
        args = cita_parser.parse_args()
        cita = Cita.query.get(cita_id)
        if not cita:
            return {"message": "Cita no encontrada"}, 404
        
        paciente_id = args['paciente_id']
        medico_id = args['medico_id']
        consultorio_id = args['consultorio_id']
        fecha_str = args['fecha']
        hora_str = args['hora']

        # Validación de formato de fecha y hora
        try:
            fecha_cita = datetime.strptime(fecha_str, '%Y-%m-%d').date()
            hora_cita = datetime.strptime(hora_str, '%H:%M:%S').time()
        except ValueError:
            return {"message": "Formato de fecha u hora inválido. Usa YYYY-MM-DD y HH:MM:SS."}, 400

        # Validación: No se puede agendar una cita en el pasado
        if fecha_cita < date.today() or \
           (fecha_cita == date.today() and hora_cita < datetime.now().time()):
            return {"message": "No se puede agendar una cita en el pasado."}, 400

        # Validación: Horario de atención
        if not (time(8, 0, 0) <= hora_cita <= time(18, 0, 0)):
            return {"message": "La hora de la cita debe estar entre las 08:00:00 y las 18:00:00."}, 400

        # Validación de existencia de claves foráneas
        paciente = Paciente.query.get(paciente_id)
        if not paciente:
            return {"message": f"Paciente con ID {paciente_id} no encontrado."}, 400
        medico = Medico.query.get(medico_id)
        if not medico:
            return {"message": f"Médico con ID {medico_id} no encontrado."}, 400
        consultorio = Consultorio.query.get(consultorio_id)
        if not consultorio:
            return {"message": f"Consultorio con ID {consultorio_id} no encontrado."}, 400

        # Validación de disponibilidad para médico (excluyendo la cita actual)
        existing_cita_medico = Cita.query.filter(
            Cita.medico_id == medico_id,
            Cita.fecha == fecha_cita,
            Cita.hora == hora_cita,
            Cita.id != cita_id # Excluye la cita que estamos actualizando
        ).first()
        if existing_cita_medico:
            return {"message": "El médico ya tiene otra cita a esa fecha y hora."}, 409
        
        # Validación de disponibilidad para consultorio (excluyendo la cita actual)
        existing_cita_consultorio = Cita.query.filter(
            Cita.consultorio_id == consultorio_id,
            Cita.fecha == fecha_cita,
            Cita.hora == hora_cita,
            Cita.id != cita_id # Excluye la cita que estamos actualizando
        ).first()
        if existing_cita_consultorio:
            return {"message": "El consultorio ya está ocupado a esa fecha y hora por otra cita."}, 409

        try:
            cita.paciente_id = paciente_id
            cita.medico_id = medico_id
            cita.consultorio_id = consultorio_id
            cita.fecha = fecha_cita
            cita.hora = hora_cita
            db.session.commit()
            return {"message": "Cita actualizada correctamente", "cita": cita.to_dict()}, 200
        except Exception as e:
            db.session.rollback()
            print(f"Error al actualizar cita: {e}")
            return {"message": "Error interno del servidor al actualizar cita"}, 500

    def delete(self, cita_id):
        """
        Maneja las peticiones DELETE para eliminar una cita.
        """
        cita = Cita.query.get(cita_id)
        if not cita:
            return {"message": "Cita no encontrada"}, 404
        
        try:
            db.session.delete(cita)
            db.session.commit()
            return {"message": "Cita eliminada correctamente"}, 204
        except Exception as e:
            db.session.rollback()
            print(f"Error al eliminar cita: {e}")
            return {"message": "Error interno del servidor al eliminar cita"}, 500
