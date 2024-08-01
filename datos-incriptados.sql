CREATE EXTENSION IF NOT EXISTS pgcrypto; --esta extencion es para el comnado que usa la incritacion de la base 

-- Crear una tabla con datos sensibles
CREATE TABLE DatosSensibles (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES Usuarios(id),
    numero_tarjeta BYTEA
);

-- Insertar datos cifrados
INSERT INTO DatosSensibles (usuario_id, numero_tarjeta) VALUES
(1, pgp_sym_encrypt('4111111111111111', 'clave_secreta')),
(2, pgp_sym_encrypt('5500000000000004', 'clave_secreta'));


