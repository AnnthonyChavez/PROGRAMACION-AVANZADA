
# models.py
from extensions import db # Importa la instancia de db

class Paciente(db.Model):
    __tablename__ = 'pacientes' # Nombre explícito de la tabla
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(255), nullable=False)
    apellido = db.Column(db.String(255), nullable=False)
    fecha_nacimiento = db.Column(db.Date, nullable=False)
    email = db.Column(db.String(255), unique=True, nullable=False)

    # Relación con Citas: un paciente puede tener muchas citas
    # backref permite acceder al paciente desde la cita (e.g., cita.paciente)
    # lazy=True carga las citas solo cuando se accede a ellas
    citas = db.relationship('Cita', backref='paciente', lazy=True)

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

    # Relación con Citas: un médico puede tener muchas citas
    citas = db.relationship('Cita', backref='medico', lazy=True)

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

    # Relación con Citas: un consultorio puede tener muchas citas
    citas = db.relationship('Cita', backref='consultorio', lazy=True)

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
    # Las claves foráneas deben referenciar el __tablename__ en minúsculas y singular (o el nombre real de la tabla si es diferente)
    paciente_id = db.Column(db.Integer, db.ForeignKey('pacientes.id', ondelete="RESTRICT"), nullable=False)
    medico_id = db.Column(db.Integer, db.ForeignKey('medicos.id', ondelete="RESTRICT"), nullable=False)
    consultorio_id = db.Column(db.Integer, db.ForeignKey('consultorios.id', ondelete="RESTRICT"), nullable=False)
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
