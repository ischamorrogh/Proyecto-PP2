-- Crear base de datos
CREATE DATABASE IF NOT EXISTS pp2 CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE pp2;

-- Tabla de usuarios
CREATE TABLE usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  contraseña VARCHAR(255) NOT NULL,
  rol ENUM('cliente', 'empleado', 'admin') DEFAULT 'cliente',
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Tabla de emprendimientos
CREATE TABLE emprendimientos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  usuario_id INT NOT NULL,
  ubicacion_id INT,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Tabla de ubicaciones (ciudad, barrio, etc.)
CREATE TABLE ubicaciones (
  id INT AUTO_INCREMENT PRIMARY KEY,
  ciudad VARCHAR(100),
  barrio VARCHAR(100),
  direccion VARCHAR(255),
  latitud DECIMAL(10, 7),
  longitud DECIMAL(10, 7)
);

-- Tabla de servicios
CREATE TABLE servicios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  duracion INT NOT NULL, -- en minutos
  precio DECIMAL(10,2),
  emprendimiento_id INT NOT NULL,
  FOREIGN KEY (emprendimiento_id) REFERENCES emprendimientos(id)
);

-- Tabla de horarios disponibles
CREATE TABLE horarios_disponibles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  profesional_id INT NOT NULL,
  dia_semana ENUM('lunes','martes','miércoles','jueves','viernes','sábado','domingo'),
  hora_inicio TIME NOT NULL,
  hora_fin TIME NOT NULL,
  FOREIGN KEY (profesional_id) REFERENCES usuarios(id)
);

-- Tabla de turnos
CREATE TABLE turnos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  cliente_id INT NOT NULL,
  profesional_id INT NOT NULL,
  servicio_id INT NOT NULL,
  fecha DATE NOT NULL,
  hora TIME NOT NULL,
  estado ENUM('pendiente', 'confirmado', 'cancelado', 'completado') DEFAULT 'pendiente',
  observaciones TEXT,
  fecha_reserva TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (cliente_id) REFERENCES usuarios(id),
  FOREIGN KEY (profesional_id) REFERENCES usuarios(id),
  FOREIGN KEY (servicio_id) REFERENCES servicios(id)
);



ALTER TABLE usuarios CHANGE `contraseña` `contrasena` VARCHAR(255) NOT NULL;
