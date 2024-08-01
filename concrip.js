const express = require('express');
const router = express.Router();

module.exports = (pool) => {
    const encryptionKey = 'your-encryption-key'; // Define tu clave de encriptación y almacénala de manera segura

    // ** Rutas de Usuarios **

    // Obtener todos los usuarios sin desencriptar
    router.get('/usuarios', async (req, res) => {
        try {
            const query = 'SELECT * FROM Usuarios';
            const result = await pool.query(query);
            res.json(result.rows);
        } catch (err) {
            console.error('Error al obtener usuarios:', err.message);
            res.status(500).send("Error al obtener usuarios: " + err.message);
        }
    });

    // Obtener un usuario por ID y desencriptar datos
    router.get('/usuarios/:id', async (req, res) => {
        const { id } = req.params;
        try {
            const query = `
                SELECT
                    id,
                    pgp_sym_decrypt(nombre::bytea, $1) AS nombre,
                    pgp_sym_decrypt(email::bytea, $1) AS email,
                    pgp_sym_decrypt(password::bytea, $1) AS password,
                    fecha_registro
                FROM Usuarios
                WHERE id = $2
            `;

            const result = await pool.query(query, [encryptionKey, id]);
            res.json(result.rows[0]);
        } catch (err) {
            console.error('Error al obtener usuario:', err.message);
            res.status(500).send("Error al obtener usuario: " + err.message);
        }
    });

    // Agregar un nuevo usuario
    router.post('/usuarios', async (req, res) => {
        const { nombre, email, password } = req.body;
        try {
            const result = await pool.query(
                `INSERT INTO Usuarios (nombre, email, password, fecha_registro)
                VALUES (
                    pgp_sym_encrypt($1, $4),
                    pgp_sym_encrypt($2, $4),
                    pgp_sym_encrypt($3, $4),
                    CURRENT_TIMESTAMP
                ) RETURNING id, pgp_sym_decrypt(nombre::bytea, $4) AS nombre, pgp_sym_decrypt(email::bytea, $4) AS email, fecha_registro`,
                [nombre, email, password, encryptionKey]
            );
            res.json(result.rows[0]);
        } catch (err) {
            console.error('Error al agregar usuario:', err.message);
            res.status(500).send("Error al agregar usuario: " + err.message);
        }
    });

    // Actualizar un usuario
    router.put('/usuarios/:id', async (req, res) => {
        const { id } = req.params;
        const { nombre, email, password } = req.body;
        try {
            const result = await pool.query(
                `UPDATE Usuarios
                SET
                    nombre = pgp_sym_encrypt($1, $4),
                    email = pgp_sym_encrypt($2, $4),
                    password = pgp_sym_encrypt($3, $4)
                WHERE id = $5
                RETURNING id, pgp_sym_decrypt(nombre::bytea, $4) AS nombre, pgp_sym_decrypt(email::bytea, $4) AS email, fecha_registro`,
                [nombre, email, password, encryptionKey, id]
            );
            res.json(result.rows[0]);
        } catch (err) {
            console.error('Error al actualizar usuario:', err.message);
            res.status(500).send("Error al actualizar usuario: " + err.message);
        }
    });

    // Eliminar un usuario
    router.delete('/usuarios/:id', async (req, res) => {
        const { id } = req.params;
        try {
            const result = await pool.query(
                'DELETE FROM Usuarios WHERE id = $1 RETURNING id, pgp_sym_decrypt(nombre::bytea, $2) AS nombre, pgp_sym_decrypt(email::bytea, $2) AS email, fecha_registro',
                [id, encryptionKey]
            );
            res.json(result.rows[0]);
        } catch (err) {
            console.error('Error al eliminar usuario:', err.message);
            res.status(500).send("Error al eliminar usuario: " + err.message);
        }
    });

    return router;
};
