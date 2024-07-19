TRUNCATE TABLE Usuarios; --si es necesario 


-- Insertar datos en la tabla Usuarios
INSERT INTO Usuarios (nombre, email, password) VALUES
('Juan Pérez', 'juan.perez@example.com', 'password123'),
('María García', 'maria.garcia@example.com', 'mypassword'),
('Luis Martínez', 'luis.martinez@example.com', 'securepassword'),
('Ana López', 'ana.lopez@example.com', 'password456'),
('Pedro Sánchez', 'pedro.sanchez@example.com', 'mypassword789');

ALTER TABLE Usuarios ADD COLUMN password_encrypted TEXT;
