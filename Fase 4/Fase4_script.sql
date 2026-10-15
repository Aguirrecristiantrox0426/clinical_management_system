-- Fase 4 - Base de datos
-- Sistema de Gestion de Clinica
CREATE DATABASE IF NOT EXISTS clinical_management_system
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE clinical_management_system;

CREATE TABLE roles (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(150),
    estado ENUM('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
);

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    id_rol INT NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(120) NOT NULL UNIQUE,
    contrasena VARCHAR(255) NOT NULL,
    estado ENUM('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
    fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuarios_roles FOREIGN KEY (id_rol) REFERENCES roles(id_rol)
);

CREATE TABLE pacientes (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    documento VARCHAR(30) NOT NULL UNIQUE,
    nombres VARCHAR(80) NOT NULL,
    apellidos VARCHAR(80) NOT NULL,
    fecha_nacimiento DATE,
    sexo VARCHAR(20),
    telefono VARCHAR(30),
    correo VARCHAR(120),
    direccion VARCHAR(150),
    estado ENUM('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO'
);

CREATE TABLE medicos (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    especialidad VARCHAR(100) NOT NULL,
    numero_registro VARCHAR(50) NOT NULL UNIQUE,
    estado ENUM('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT fk_medicos_usuarios FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

CREATE TABLE disponibilidades (
    id_disponibilidad INT AUTO_INCREMENT PRIMARY KEY,
    id_medico INT NOT NULL,
    dia_semana VARCHAR(15) NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    estado ENUM('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
    CONSTRAINT chk_horario CHECK (hora_inicio < hora_fin),
    CONSTRAINT fk_disponibilidad_medicos FOREIGN KEY (id_medico) REFERENCES medicos(id_medico)
);

CREATE TABLE citas (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    estado ENUM('PROGRAMADA','REPROGRAMADA','EN_ATENCION','ATENDIDA','CANCELADA') NOT NULL DEFAULT 'PROGRAMADA',
    motivo_consulta VARCHAR(200),
    observaciones VARCHAR(250),
    CONSTRAINT uq_cita_medico_horario UNIQUE (id_medico, fecha, hora),
    CONSTRAINT fk_citas_pacientes FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    CONSTRAINT fk_citas_medicos FOREIGN KEY (id_medico) REFERENCES medicos(id_medico)
);

CREATE TABLE atenciones (
    id_atencion INT AUTO_INCREMENT PRIMARY KEY,
    id_cita INT NOT NULL UNIQUE,
    id_medico INT NOT NULL,
    fecha_atencion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    motivo_consulta VARCHAR(200) NOT NULL,
    observaciones TEXT,
    resultado TEXT,
    CONSTRAINT fk_atenciones_citas FOREIGN KEY (id_cita) REFERENCES citas(id_cita),
    CONSTRAINT fk_atenciones_medicos FOREIGN KEY (id_medico) REFERENCES medicos(id_medico)
);

CREATE TABLE notificaciones (
    id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    mensaje VARCHAR(255) NOT NULL,
    fecha_envio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('PENDIENTE','ENVIADA','LEIDA') NOT NULL DEFAULT 'PENDIENTE',
    CONSTRAINT fk_notificaciones_usuarios FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

CREATE TABLE reportes (
    id_reporte INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    tipo VARCHAR(80) NOT NULL,
    fecha_generacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    formato VARCHAR(20) NOT NULL,
    estado ENUM('GENERADO','CANCELADO') NOT NULL DEFAULT 'GENERADO',
    CONSTRAINT fk_reportes_usuarios FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

INSERT INTO roles (nombre, descripcion) VALUES
('RECEPCIONISTA', 'Gestion administrativa de pacientes y citas'),
('MEDICO', 'Consulta y registro de atenciones medicas'),
('ADMINISTRADOR', 'Gestion de usuarios, roles, medicos y reportes');

INSERT INTO usuarios (id_rol, nombre, correo, contrasena) VALUES
(1, 'Laura Gomez', 'laura.gomez@clinica.test', 'CAMBIAR_HASH_1'),
(2, 'Carlos Perez', 'carlos.perez@clinica.test', 'CAMBIAR_HASH_2'),
(3, 'Ana Torres', 'ana.torres@clinica.test', 'CAMBIAR_HASH_3');

INSERT INTO pacientes (documento, nombres, apellidos, fecha_nacimiento, sexo, telefono, correo, direccion) VALUES
('1001001001', 'Maria', 'Rodriguez', '1995-04-18', 'F', '3000000001', 'maria.rodriguez@correo.test', 'Neiva'),
('1001001002', 'Juan', 'Martinez', '1988-09-02', 'M', '3000000002', 'juan.martinez@correo.test', 'Neiva');

INSERT INTO medicos (id_usuario, especialidad, numero_registro) VALUES
(2, 'Medicina general', 'RM-0001');

INSERT INTO disponibilidades (id_medico, dia_semana, hora_inicio, hora_fin) VALUES
(1, 'LUNES', '08:00:00', '12:00:00'),
(1, 'MIERCOLES', '14:00:00', '18:00:00');

INSERT INTO citas (id_paciente, id_medico, fecha, hora, estado, motivo_consulta) VALUES
(1, 1, '2026-10-20', '08:30:00', 'PROGRAMADA', 'Consulta general'),
(2, 1, '2026-10-21', '14:30:00', 'PROGRAMADA', 'Control medico');

INSERT INTO atenciones (id_cita, id_medico, motivo_consulta, observaciones, resultado) VALUES
(1, 1, 'Consulta general', 'Paciente estable.', 'Continuar seguimiento medico.');

INSERT INTO notificaciones (id_usuario, tipo, mensaje, estado) VALUES
(1, 'CITA', 'La cita del paciente fue programada.', 'ENVIADA');

INSERT INTO reportes (id_usuario, tipo, formato) VALUES
(3, 'Citas programadas', 'PDF');
