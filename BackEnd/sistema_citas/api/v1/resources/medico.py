# api/v1/resources/medico.py
from flask_restful import Resource
from extensions import db
from models import Medico
from api.v1.parsers import medico_parser

class MedicoResource(Resource):
    def get(self, medico_id=None):
        """
        Maneja las peticiones GET para obtener uno o todos los médicos.
        """
        if medico_id:
            medico = Medico.query.get(medico_id)
            if not medico:
                return {"message": "Médico no encontrado"}, 404
            return medico.to_dict(), 200
        
        medicos = Medico.query.all()
        return [m.to_dict() for m in medicos], 200

    def post(self):
        """
        Maneja las peticiones POST para crear un nuevo médico.
        """
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
        """
        Maneja las peticiones PUT para actualizar un médico existente.
        """
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
        """
        Maneja las peticiones DELETE para eliminar un médico.
        Impide la eliminación si el médico tiene citas asociadas.
        """
        medico = Medico.query.get(medico_id)
        if not medico:
            return {"message": "Médico no encontrado"}, 404
        
        try:
            # Restricción: No se puede eliminar si tiene citas asociadas
            if medico.citas: # 'citas' es la relación que definimos en models.py
                return {"message": "No se puede eliminar el médico porque tiene citas asociadas. Elimina las citas primero."}, 409

            db.session.delete(medico)
            db.session.commit()
            return {"message": "Médico eliminado correctamente"}, 204
        except Exception as e:
            db.session.rollback()
            print(f"Error al eliminar médico: {e}")
            return {"message": "Error interno del servidor al eliminar médico"}, 500
