import datetime
from flask import request
from flask_restful import Resource, reqparse
from extensions import db, api

from models import Paciente, Medico, Consultorio, Cita

# --- Parsers para validar y obtener datos de las peticiones ---
paciente_parser = reqparse.RequestParser()
paciente_parser.add_argument("nombre", type=str, required=True, help="Nombre es obligatorio")
paciente_parser.add_argument("apellido", type=str, required=True, help="Apellido es obligatorio")
paciente_parser.add_argument("fecha_nacimiento", type=str, required=True, help="Fecha de nacimiento es obligatoria (YYYY-MM-DD)")
paciente_parser.add_argument("email", type=str, required=True, help="Email es obligatorio y único")

medico_parser = reqparse.RequestParser()
medico_parser.add_argument("nombre", type=str, required=True, help="Nombre es obligatorio")
medico_parser.add_argument("apellido", type=str, required=True, help="Apellido es obligatorio")
medico_parser.add_argument("especialidad", type=str, required=True, help="Especialidad es obligatoria")

consultorio_parser = reqparse.RequestParser()
consultorio_parser.add_argument("numero", type=str, required=True, help="Número de consultorio es obligatorio y único")
consultorio_parser.add_argument("piso", type=int, required=True, help="Piso es obligatorio")

cita_parser = reqparse.RequestParser()
cita_parser.add_argument("paciente_id", type=int, required=True, help="ID del paciente es obligatorio")
cita_parser.add_argument("medico_id", type=int, required=True, help="ID del médico es obligatorio")
cita_parser.add_argument("consultorio_id", type=int, required=True, help="ID del consultorio es obligatorio")
cita_parser.add_argument("fecha", type=str, required=True, help="Fecha de la cita es obligatoria (YYYY-MM-DD)")
cita_parser.add_argument("hora", type=str, required=True, help="Hora de la cita es obligatoria (HH:MM:SS)")

# --- Recurso para Pacientes ---
class PacienteResource(Resource):
    # GET para obtener un paciente por ID o todos los pacientes
    def get(self, paciente_id=None):
        if paciente_id:
            paciente = Paciente.query.get(paciente_id)
            if not paciente:
                return {"message": "Paciente no encontrado"}, 404
            return paciente.to_dict()
        
        pacientes = Paciente.query.all()
        return [p.to_dict() for p in pacientes]

    # POST para crear un nuevo paciente
    def post(self):
        args = paciente_parser.parse_args()
        try:
            existing_paciente = Paciente.query.filter_by(email=args['email']).first()
            if existing_paciente:
                return {"message": "El email ya está registrado"}, 409

            nuevo_paciente = Paciente(
                nombre=args['nombre'],
                apellido=args['apellido'],
                fecha_nacimiento=args['fecha_nacimiento'],
                email=args['email']
            )
            db.session.add(nuevo_paciente)
            db.session.commit()
            return {"message": "Paciente agregado correctamente", "paciente": nuevo_paciente.to_dict()}, 201
        except Exception as e:
            db.session.rollback()
            print(f"Error al crear paciente: {e}")
            return {"message": "Error interno del servidor al crear paciente"}, 500

    # PUT para actualizar un paciente existente
    def put(self, paciente_id):
        args = paciente_parser.parse_args()
        paciente = Paciente.query.get(paciente_id)
        if not paciente:
            return {"message": "Paciente no encontrado"}, 404
        
        try:
            if args['email'] and args['email'] != paciente.email:
                existing_paciente = Paciente.query.filter_by(email=args['email']).first()
                if existing_paciente and existing_paciente.id != paciente_id:
                    return {"message": "El email ya está registrado para otro paciente"}, 409

            paciente.nombre = args['nombre']
            paciente.apellido = args['apellido']
            paciente.fecha_nacimiento = datetime.datetime.strptime(args['fecha_nacimiento'], '%Y-%m-%d').date() # Asegurar formato de fecha
            paciente.email = args['email']
            db.session.commit()
            return {"message": "Paciente actualizado correctamente", "paciente": paciente.to_dict()}, 200
        except Exception as e:
            db.session.rollback()
            print(f"Error al actualizar paciente: {e}")
            return {"message": "Error interno del servidor al actualizar paciente"}, 500

    # DELETE para eliminar un paciente
    def delete(self, paciente_id):
        paciente = Paciente.query.get(paciente_id)
        if not paciente:
            return {"message": "Paciente no encontrado"}, 404
        
        try:
            db.session.delete(paciente)
            db.session.commit()
            return {"message": "Paciente eliminado correctamente"}, 204
        except Exception as e:
            db.session.rollback()
            print(f"Error al eliminar paciente: {e}")
            return {"message": "Error interno del servidor al eliminar paciente"}, 500

# --- Recurso para Médicos ---
class MedicoResource(Resource):
    def get(self, medico_id=None):
        if medico_id:
            medico = Medico.query.get(medico_id)
            if not medico:
                return {"message": "Médico no encontrado"}, 404
            return medico.to_dict()
        
        medicos = Medico.query.all()
        return [m.to_dict() for m in medicos]

    def post(self):
        args = medico_parser.parse_args()
        try:
            nuevo_medico = Medico(**args)
            db.session.add(nuevo_medico)
            db.session.commit()
            return {"message": "Médico agregado correctamente", "medico": nuevo_medico.to_dict()}, 201
        except Exception as e:
            db.session.rollback()
            print(f"Error al crear médico: {e}")
            return {"message": "Error interno del servidor al crear médico"}, 500
    
    def put(self, medico_id):
        args = medico_parser.parse_args()
        medico = Medico.query.get(medico_id)
        if not medico:
            return {"message": "Médico no encontrado"}, 404
        
        try:
            medico.nombre = args['nombre']
            medico.apellido = args['apellido']
            medico.especialidad = args['especialidad']
            db.session.commit()
            return {"message": "Médico actualizado correctamente", "medico": medico.to_dict()}, 200
        except Exception as e:
            db.session.rollback()
            print(f"Error al actualizar médico: {e}")
            return {"message": "Error interno del servidor al actualizar médico"}, 500

    def delete(self, medico_id):
        medico = Medico.query.get(medico_id)
        if not medico:
            return {"message": "Médico no encontrado"}, 404
        
        try:
            db.session.delete(medico)
            db.session.commit()
            return {"message": "Médico eliminado correctamente"}, 204
        except Exception as e:
            db.session.rollback()
            print(f"Error al eliminar médico: {e}")
            return {"message": "Error interno del servidor al eliminar médico"}, 500

# --- Recurso para Consultorios ---
class ConsultorioResource(Resource):
    def get(self, consultorio_id=None):
        if consultorio_id:
            consultorio = Consultorio.query.get(consultorio_id)
            if not consultorio:
                return {"message": "Consultorio no encontrado"}, 404
            return consultorio.to_dict()
        
        consultorios = Consultorio.query.all()
        return [c.to_dict() for c in consultorios]

    def post(self):
        args = consultorio_parser.parse_args()
        try:
            existing_consultorio = Consultorio.query.filter_by(numero=args['numero']).first()
            if existing_consultorio:
                return {"message": "El número de consultorio ya existe"}, 409

            nuevo_consultorio = Consultorio(**args)
            db.session.add(nuevo_consultorio)
            db.session.commit()
            return {"message": "Consultorio agregado correctamente", "consultorio": nuevo_consultorio.to_dict()}, 201
        except Exception as e:
            db.session.rollback()
            print(f"Error al crear consultorio: {e}")
            return {"message": "Error interno del servidor al crear consultorio"}, 500
    
    def put(self, consultorio_id):
        args = consultorio_parser.parse_args()
        consultorio = Consultorio.query.get(consultorio_id)
        if not consultorio:
            return {"message": "Consultorio no encontrado"}, 404
        
        try:
            if args['numero'] and args['numero'] != consultorio.numero:
                existing_consultorio = Consultorio.query.filter_by(numero=args['numero']).first()
                if existing_consultorio and existing_consultorio.id != consultorio_id:
                    return {"message": "El número de consultorio ya existe para otro consultorio"}, 409

            consultorio.numero = args['numero']
            consultorio.piso = args['piso']
            db.session.commit() # ¡Importante: no olvides el commit!
            return {"message": "Consultorio actualizado correctamente", "consultorio": consultorio.to_dict()}, 200
        except Exception as e:
            db.session.rollback()
            print(f"Error al actualizar consultorio: {e}")
            return {"message": "Error interno del servidor al actualizar consultorio"}, 500

    def delete(self, consultorio_id):
        consultorio = Consultorio.query.get(consultorio_id)
        if not consultorio:
            return {"message": "Consultorio no encontrado"}, 404
        
        try:
            db.session.delete(consultorio)
            db.session.commit()
            return {"message": "Consultorio eliminado correctamente"}, 204
        except Exception as e:
            db.session.rollback()
            print(f"Error al eliminar consultorio: {e}")
            return {"message": "Error interno del servidor al eliminar consultorio"}, 500

# --- Recurso para Citas ---
class CitaResource(Resource):
    def get(self, cita_id=None):
        if cita_id:
            cita = Cita.query.get(cita_id)
            if not cita:
                return {"message": "Cita no encontrada"}, 404
            return cita.to_dict()
        
        citas = Cita.query.all()
        return [c.to_dict() for c in citas]

    def post(self):
        args = cita_parser.parse_args()
        try:
            # Validaciones de existencia de FKs
            paciente = Paciente.query.get(args['paciente_id'])
            if not paciente:
                return {"message": "Paciente no encontrado"}, 400
            medico = Medico.query.get(args['medico_id'])
            if not medico:
                return {"message": "Médico no encontrado"}, 400
            consultorio = Consultorio.query.get(args['consultorio_id'])
            if not consultorio:
                return {"message": "Consultorio no encontrado"}, 400

            # Validación de fecha y hora futura
            fecha_cita = datetime.datetime.strptime(args['fecha'], '%Y-%m-%d').date()
            hora_cita = datetime.datetime.strptime(args['hora'], '%H:%M:%S').time()
            
            if fecha_cita < datetime.date.today() or \
               (fecha_cita == datetime.date.today() and hora_cita < datetime.datetime.now().time()):
                return {"message": "No se puede agendar una cita en el pasado"}, 400

            # Validación de disponibilidad (mismo médico, misma fecha y hora)
            existing_cita = Cita.query.filter_by(
                medico_id=args['medico_id'],
                fecha=fecha_cita,
                hora=hora_cita
            ).first()
            if existing_cita:
                return {"message": "El médico ya tiene una cita a esa fecha y hora"}, 409
            
            # Validación de disponibilidad (mismo consultorio, misma fecha y hora)
            existing_cita_consultorio = Cita.query.filter_by(
                consultorio_id=args['consultorio_id'],
                fecha=fecha_cita,
                hora=hora_cita
            ).first()
            if existing_cita_consultorio:
                return {"message": "El consultorio ya está ocupado a esa fecha y hora"}, 409


            nueva_cita = Cita(
                paciente_id=args['paciente_id'],
                medico_id=args['medico_id'],
                consultorio_id=args['consultorio_id'],
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
        args = cita_parser.parse_args()
        cita = Cita.query.get(cita_id)
        if not cita:
            return {"message": "Cita no encontrada"}, 404
        
        try:
            # Validaciones de existencia de FKs
            paciente = Paciente.query.get(args['paciente_id'])
            if not paciente:
                return {"message": "Paciente no encontrado"}, 400
            medico = Medico.query.get(args['medico_id'])
            if not medico:
                return {"message": "Médico no encontrado"}, 400
            consultorio = Consultorio.query.get(args['consultorio_id'])
            if not consultorio:
                return {"message": "Consultorio no encontrado"}, 400

            # Validación de fecha y hora futura
            fecha_cita = datetime.datetime.strptime(args['fecha'], '%Y-%m-%d').date()
            hora_cita = datetime.datetime.strptime(args['hora'], '%H:%M:%S').time()
            
            if fecha_cita < datetime.date.today() or \
               (fecha_cita == datetime.date.today() and hora_cita < datetime.datetime.now().time()):
                return {"message": "No se puede agendar una cita en el pasado"}, 400

            # Validación de disponibilidad para médico y consultorio (excluyendo la cita actual)
            existing_cita_medico = Cita.query.filter(
                Cita.medico_id == args['medico_id'],
                Cita.fecha == fecha_cita,
                Cita.hora == hora_cita,
                Cita.id != cita_id
            ).first()
            if existing_cita_medico:
                return {"message": "El médico ya tiene otra cita a esa fecha y hora"}, 409
            
            existing_cita_consultorio = Cita.query.filter(
                Cita.consultorio_id == args['consultorio_id'],
                Cita.fecha == fecha_cita,
                Cita.hora == hora_cita,
                Cita.id != cita_id
            ).first()
            if existing_cita_consultorio:
                return {"message": "El consultorio ya está ocupado a esa fecha y hora por otra cita"}, 409

            cita.paciente_id = args['paciente_id']
            cita.medico_id = args['medico_id']
            cita.consultorio_id = args['consultorio_id']
            cita.fecha = fecha_cita
            cita.hora = hora_cita
            db.session.commit()
            return {"message": "Cita actualizada correctamente", "cita": cita.to_dict()}, 200
        except Exception as e:
            db.session.rollback()
            print(f"Error al actualizar cita: {e}")
            return {"message": "Error interno del servidor al actualizar cita"}, 500

    def delete(self, cita_id):
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

# Registro de Recursos de API (usando la instancia 'api' directamente)
api.add_resource(PacienteResource, "/api/pacientes", "/api/pacientes/<int:paciente_id>")
api.add_resource(MedicoResource, "/api/medicos", "/api/medicos/<int:medico_id>")
api.add_resource(ConsultorioResource, "/api/consultorios", "/api/consultorios/<int:consultorio_id>")
api.add_resource(CitaResource, "/api/citas", "/api/citas/<int:cita_id>")