# models.py
from extensions import db # Importa la instancia de db

class Paciente(db.Model):
    __tablename__ = 'pacientes' # Nombre explícito de la tabla
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(255), nullable=False)
    apellido = db.Column(db.String(255), nullable=False)
    fecha_nacimiento = db.Column(db.Date, nullable=False)
    email = db.Column(db.String(255), unique=True, nullable=False)

    def to_dict(self):
        return {
            'id': self.id,
            'nombre': self.nombre,
            'apellido': self.apellido,
            'fecha_nacimiento': self.fecha_nacimiento.strftime('%Y-%m-%d') if self.fecha_nacimiento else None,
            'email': self.email
        }

    def __repr__(self):
        return f"<Paciente {self.nombre} {self.apellido}>"

class Medico(db.Model):
    __tablename__ = 'medicos' # Nombre explícito de la tabla
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(255), nullable=False)
    apellido = db.Column(db.String(255), nullable=False)
    especialidad = db.Column(db.String(255), nullable=False)

    def to_dict(self):
        return {
            'id': self.id,
            'nombre': self.nombre,
            'apellido': self.apellido,
            'especialidad': self.especialidad
        }

    def __repr__(self):
        return f"<Medico {self.nombre} {self.apellido}>"

class Consultorio(db.Model):
    __tablename__ = 'consultorios' # Nombre explícito de la tabla
    id = db.Column(db.Integer, primary_key=True)
    numero = db.Column(db.String(50), unique=True, nullable=False)
    piso = db.Column(db.Integer, nullable=False)

    def to_dict(self):
        return {
            'id': self.id,
            'numero': self.numero,
            'piso': self.piso
        }

    def __repr__(self):
        return f"<Consultorio {self.numero} - Piso {self.piso}>"

class Cita(db.Model):
    __tablename__ = 'citas' # Nombre explícito de la tabla
    id = db.Column(db.Integer, primary_key=True)
    # !!! IMPORTANTE: Las claves foráneas deben referenciar el __tablename__ en minúsculas y singular (o el nombre real de la tabla si es diferente)
    paciente_id = db.Column(db.Integer, db.ForeignKey('pacientes.id', ondelete="RESTRICT"), nullable=False) # Cambiado a 'pacientes.id'
    medico_id = db.Column(db.Integer, db.ForeignKey('medicos.id', ondelete="RESTRICT"), nullable=False)     # Cambiado a 'medicos.id'
    consultorio_id = db.Column(db.Integer, db.ForeignKey('consultorios.id', ondelete="RESTRICT"), nullable=False) # Cambiado a 'consultorios.id'
    fecha = db.Column(db.Date, nullable=False)
    hora = db.Column(db.Time, nullable=False)

    def to_dict(self):
        return {
            'id': self.id,
            'paciente_id': self.paciente_id,
            'medico_id': self.medico_id,
            'consultorio_id': self.consultorio_id,
            'fecha': self.fecha.strftime('%Y-%m-%d') if self.fecha else None,
            'hora': self.hora.strftime('%H:%M:%S') if self.hora else None
        }

    def __repr__(self):
        return f"<Cita ID: {self.id} - Fecha: {self.fecha} Hora: {self.hora}>"
