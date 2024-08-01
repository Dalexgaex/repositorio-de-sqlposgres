TRUNCATE TABLE Usuarios; --si es necesario 


-- Insertar datos en la tabla Usuarios
INSERT INTO Usuarios (nombre, email, password) VALUES
('Juan Pérez', 'juan.perez@example.com', 'password123'),
('María García', 'maria.garcia@example.com', 'mypassword'),
('Luis Martínez', 'luis.martinez@example.com', 'securepassword'),
('Ana López', 'ana.lopez@example.com', 'password456'),
('Pedro Sánchez', 'pedro.sanchez@example.com', 'mypassword789');

-- Paso 2: Crear una columna temporal para el cifrado (opcional)
ALTER TABLE Usuarios ADD COLUMN password_encrypted TEXT;

-- Paso 3: Cifrar los datos existentes
UPDATE Usuarios
SET password_encrypted = crypt(password, gen_salt('bf'));

-- Paso 4: Verificar los datos cifrados (opcional)
SELECT id, nombre, email, password_encrypted FROM Usuarios;

-- Paso 5: Remover la columna antigua y renombrar la columna cifrada
ALTER TABLE Usuarios DROP COLUMN password;
ALTER TABLE Usuarios RENAME COLUMN password_encrypted TO password;

