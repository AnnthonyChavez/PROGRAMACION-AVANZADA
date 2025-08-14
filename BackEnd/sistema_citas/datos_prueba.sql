-- Insertar Pacientes
INSERT INTO Pacientes (nombre, apellido, fecha_nacimiento, email) VALUES
('Juan', 'Pérez', '1990-05-14', 'juan.perez@email.com'),
('María', 'López', '1985-09-21', 'maria.lopez@email.com');

-- Insertar Médicos
INSERT INTO Medicos (nombre, apellido, especialidad) VALUES
('Carlos', 'Gómez', 'Cardiología'),
('Ana', 'Torres', 'Pediatría');

-- Insertar Consultorios
INSERT INTO Consultorios (numero, piso) VALUES
('101', 1),
('202', 2);

-- Insertar Citas
INSERT INTO Citas (paciente_id, medico_id, fecha, hora, consultorio_id) VALUES
(1, 1, '2025-08-15', '09:00', 1),
(2, 2, '2025-08-16', '10:30', 2);
