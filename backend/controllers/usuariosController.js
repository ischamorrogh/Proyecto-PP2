const db = require('../config/db');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// Registro de usuario
exports.registro = async (req, res) => {
  const { nombre, apellido, email, contrasena } = req.body;

  console.log('BODY recibido en registro:', req.body);

  if (!nombre || !apellido || !email || !contrasena) {
    return res.status(400).json({ mensaje: 'Todos los campos son obligatorios' });
  }

  try {
    const [existe] = await db.query('SELECT id FROM usuarios WHERE email = ?', [email]);
    if (existe.length > 0) {
      return res.status(400).json({ mensaje: 'El email ya está registrado' });
    }

    const hash = await bcrypt.hash(contrasena, 10);
    await db.query('INSERT INTO usuarios (nombre, apellido, email, contrasena) VALUES (?, ?, ?, ?)', [
      nombre,
      apellido,
      email,
      hash,
    ]);

    res.status(201).json({ mensaje: 'Usuario registrado con éxito' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ mensaje: 'Error al registrar usuario' });
  }
};

// Login
exports.login = async (req, res) => {
  const { email, contrasena } = req.body;

  if (!email || !contrasena) {
    return res.status(400).json({ mensaje: 'Email y contraseña son requeridos' });
  }

  try {
    const [usuarios] = await db.query('SELECT * FROM usuarios WHERE email = ?', [email]);

    if (usuarios.length === 0) {
      return res.status(401).json({ mensaje: 'Credenciales inválidas' });
    }

    const usuario = usuarios[0];
    const validPassword = await bcrypt.compare(contrasena, usuario.contrasena);

    if (!validPassword) {
      return res.status(401).json({ mensaje: 'Credenciales inválidas' });
    }

    const token = jwt.sign(
      { id: usuario.id, rol: usuario.rol },
      process.env.JWT_SECRET,
      { expiresIn: '8h' }
    );

    res.json({ token, usuario: { id: usuario.id, nombre: usuario.nombre, apellido: usuario.apellido, rol: usuario.rol } });
  } catch (error) {
    console.error(error);
    res.status(500).json({ mensaje: 'Error al iniciar sesión' });
  }
};
