INSERT INTO Usuarios (nombre, email, password, fecha_registro)
VALUES (
    pgp_sym_encrypt('John Doe', 'your-encryption-key'),
    pgp_sym_encrypt('johndoe@example.com', 'your-encryption-key'),
    pgp_sym_encrypt('password123', 'your-encryption-key'),
    CURRENT_TIMESTAMP
);


SELECT
    id,
    pgp_sym_decrypt(nombre::bytea, 'your-encryption-key') AS nombre,
    pgp_sym_decrypt(email::bytea, 'your-encryption-key') AS email,
    pgp_sym_decrypt(password::bytea, 'your-encryption-key') AS password,
    fecha_registro
FROM Usuarios;
