# api/v1/resources/consultorio.py
from flask_restful import Resource
from extensions import db
from models import Consultorio
from api.v1.parsers import consultorio_parser

class ConsultorioResource(Resource):
    def get(self, consultorio_id=None):
        """
        Maneja las peticiones GET para obtener uno o todos los consultorios.
        """
        if consultorio_id:
            consultorio = Consultorio.query.get(consultorio_id)
            if not consultorio:
                return {"message": "Consultorio no encontrado"}, 404
            return consultorio.to_dict(), 200
        
        consultorios = Consultorio.query.all()
        return [c.to_dict() for c in consultorios], 200

    def post(self):
        """
        Maneja las peticiones POST para crear un nuevo consultorio.
        Incluye validación para el piso (debe ser positivo) y unicidad del número.
        """
        args = consultorio_parser.parse_args()
        numero = args['numero']
        piso = args['piso']

        # Validación: El piso debe ser un número entero positivo
        if piso <= 0:
            return {"message": "El piso debe ser un número entero positivo."}, 400

        try:
            # Verificar si el número de consultorio ya existe
            existing_consultorio = Consultorio.query.filter_by(numero=numero).first()
            if existing_consultorio:
                return {"message": "El número de consultorio ya existe"}, 409

            nuevo_consultorio = Consultorio(numero=numero, piso=piso)
            db.session.add(nuevo_consultorio)
            db.session.commit()
            return {"message": "Consultorio agregado correctamente", "consultorio": nuevo_consultorio.to_dict()}, 201
        except Exception as e:
            db.session.rollback()
            print(f"Error al crear consultorio: {e}")
            return {"message": "Error interno del servidor al crear consultorio"}, 500
    
    def put(self, consultorio_id):
        """
        Maneja las peticiones PUT para actualizar un consultorio existente.
        Incluye las mismas validaciones que POST para el piso y unicidad del número.
        """
        args = consultorio_parser.parse_args()
        consultorio = Consultorio.query.get(consultorio_id)
        if not consultorio:
            return {"message": "Consultorio no encontrado"}, 404
        
        numero = args['numero']
        piso = args['piso']

        # Validación: El piso debe ser un número entero positivo
        if piso <= 0:
            return {"message": "El piso debe ser un número entero positivo."}, 400

        try:
            # Verificar unicidad del número si se ha cambiado
            if numero != consultorio.numero:
                existing_consultorio = Consultorio.query.filter_by(numero=numero).first()
                if existing_consultorio and existing_consultorio.id != consultorio_id:
                    return {"message": "El número de consultorio ya existe para otro consultorio"}, 409

            consultorio.numero = numero
            consultorio.piso = piso
            db.session.commit()
            return {"message": "Consultorio actualizado correctamente", "consultorio": consultorio.to_dict()}, 200
        except Exception as e:
            db.session.rollback()
            print(f"Error al actualizar consultorio: {e}")
            return {"message": "Error interno del servidor al actualizar consultorio"}, 500

    def delete(self, consultorio_id):
        """
        Maneja las peticiones DELETE para eliminar un consultorio.
        Impide la eliminación si el consultorio tiene citas asociadas.
        """
        consultorio = Consultorio.query.get(consultorio_id)
        if not consultorio:
            return {"message": "Consultorio no encontrado"}, 404
        
        try:
            # Restricción: No se puede eliminar si tiene citas asociadas
            if consultorio.citas: # 'citas' es la relación que definimos en models.py
                return {"message": "No se puede eliminar el consultorio porque tiene citas asociadas. Elimina las citas primero."}, 409

            db.session.delete(consultorio)
            db.session.commit()
            return {"message": "Consultorio eliminado correctamente"}, 204
        except Exception as e:
            db.session.rollback()
            print(f"Error al eliminar consultorio: {e}")
            return {"message": "Error interno del servidor al eliminar consultorio"}, 500
