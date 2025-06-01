use grupo_bikemia;
-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS grupo_bikemia DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE grupo_bikemia;

-- Tabela de usuários
CREATE TABLE IF NOT EXISTS usuarios (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  apelido VARCHAR(50) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  telefone VARCHAR(20),
  senha VARCHAR(255) NOT NULL,
  data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de trilhas
CREATE TABLE IF NOT EXISTS trilhas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  data DATE NOT NULL,
  dificuldade VARCHAR(50),
  local VARCHAR(100),
  descricao TEXT,
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de eventos
CREATE TABLE IF NOT EXISTS eventos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  data DATE NOT NULL,
  local VARCHAR(100),
  descricao TEXT,
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de inscrições em trilhas
CREATE TABLE IF NOT EXISTS inscricoes_trilhas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL,
  id_trilha INT NOT NULL,
  data_inscricao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_usuario) REFERENCES usuarios(id),
  FOREIGN KEY (id_trilha) REFERENCES trilhas(id)
);

-- Tabela de newsletter
CREATE TABLE IF NOT EXISTS newsletter (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(100) NOT NULL,
  data_inscricao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
show table status;

