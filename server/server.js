import express from 'express';
import cors from 'cors';
import { createServer } from 'http';
import { Server } from 'socket.io';
import bcrypt from 'bcrypt';

const app = express();
const server = createServer(app);
const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST']
  }
});

// Configurações
const PORT = process.env.PORT || 3000;
const API_VERSION = 'v1';
const BASE_URL = `/api/${API_VERSION}`;
const SALT_ROUNDS = 10;

// Middlewares
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST'],
  allowedHeaders: ['Content-Type']
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Banco de dados em memória (simulado)
let usuarios = [{
  id: 1,
  nome: "Admin Bikemia",
  apelido: "admin",
  email: "admin@bikemia.com",
  senha: bcrypt.hashSync("123456", SALT_ROUNDS),
  telefone: "(31) 99999-9999",
  dataCadastro: new Date()
}];

let trilhas = [ /* ... */ ];
let eventos = [ /* ... */ ];

// Rotas
app.get(`${BASE_URL}/`, (req, res) => {
  res.json({
    message: 'Bem-vindo à API do Grupo Bikemia!',
    version: API_VERSION,
    endpoints: {
      usuarios: `${BASE_URL}/usuarios`,
      trilhas: `${BASE_URL}/trilhas`,
      eventos: `${BASE_URL}/eventos`
    }
  });
});

app.post(`${BASE_URL}/usuarios/cadastro`, async (req, res) => {
  try {
    const { nome, apelido, email, telefone, senha } = req.body;

    if (!nome || !apelido || !email || !senha) {
      return res.status(400).json({ success: false, message: 'Campos obrigatórios ausentes.' });
    }

    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      return res.status(400).json({ success: false, message: 'E-mail inválido.' });
    }

    if (senha.length < 6) {
      return res.status(400).json({ success: false, message: 'Senha fraca.' });
    }

    if (usuarios.some(u => u.email === email)) {
      return res.status(409).json({ success: false, message: 'E-mail já cadastrado.' });
    }

    const senhaHash = await bcrypt.hash(senha, SALT_ROUNDS);
    const novoUsuario = {
      id: usuarios.length + 1,
      nome,
      apelido,
      email,
      telefone,
      senha: senhaHash,
      dataCadastro: new Date()
    };

    usuarios.push(novoUsuario);
    io.emit('novo_usuario', novoUsuario);

    res.status(201).json({
      success: true,
      message: 'Cadastro realizado com sucesso!',
      usuario: { id: novoUsuario.id, nome, apelido, email }
    });
  } catch (error) {
    console.error('Erro no cadastro:', error);
    res.status(500).json({ success: false, message: 'Erro interno no servidor' });
  }
});

app.post(`${BASE_URL}/usuarios/login`, async (req, res) => {
  try {
    const { usuario, senha } = req.body;

    if (!usuario || !senha) {
      return res.status(400).json({ success: false, message: 'Usuário e senha obrigatórios.' });
    }

    const usuarioEncontrado = usuarios.find(u =>
      u.email === usuario || u.apelido === usuario
    );

    if (!usuarioEncontrado) {
      return res.status(401).json({ success: false, message: 'Usuário não encontrado.' });
    }

    const senhaValida = await bcrypt.compare(senha, usuarioEncontrado.senha);

    if (!senhaValida) {
      return res.status(401).json({ success: false, message: 'Senha incorreta.' });
    }

    res.json({
      success: true,
      message: 'Login realizado com sucesso!',
      usuario: {
        id: usuarioEncontrado.id,
        nome: usuarioEncontrado.nome,
        apelido: usuarioEncontrado.apelido,
        email: usuarioEncontrado.email
      }
    });
  } catch (error) {
    console.error('❌ Erro interno no login:', error);
    res.status(500).json({ success: false, message: 'Erro interno no servidor' });
  }
});

// Inicia o servidor
server.listen(PORT, () => {
  console.log(`🟢 Servidor rodando na porta ${PORT}`);
  console.log(`🔗 Acesse: http://localhost:${PORT}${BASE_URL}`);
});
