CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE EXTENSION pgagent;



-- Tabla Usuarios
CREATE TABLE Usuarios (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO Usuarios (nombre, email, password) VALUES
('Juan Pérez', 'juan.perez@example.com', crypt('password123', gen_salt('bf'))),
('María García', 'maria.garcia@example.com', crypt('mypassword', gen_salt('bf'))),
('Luis Martínez', 'luis.martinez@example.com', crypt('securepassword', gen_salt('bf'))),
('Ana López', 'ana.lopez@example.com', crypt('password456', gen_salt('bf'))),
('Pedro Sánchez', 'pedro.sanchez@example.com', crypt('mypassword789', gen_salt('bf')));

-- Cambiar el tipo de las columnas para BYTEA
ALTER TABLE Usuarios
    ALTER COLUMN nombre TYPE BYTEA USING nombre::BYTEA,
    ALTER COLUMN email TYPE BYTEA USING email::BYTEA,
    ALTER COLUMN password TYPE BYTEA USING password::BYTEA;


SELECT
    id,
    pgp_sym_decrypt(nombre::bytea, 'your_encryption_key') AS nombre,
    pgp_sym_decrypt(email::bytea, 'your_encryption_key') AS email,
    pgp_sym_decrypt(password::bytea, 'your_encryption_key') AS password,
    fecha_registro
FROM Usuarios;



