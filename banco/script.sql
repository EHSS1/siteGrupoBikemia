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
SHOW COLUMNS FROM usuarios;
SELECT * FROM usuarios;

CREATE TABLE sessoes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  token VARCHAR(255) NOT NULL,
  criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
  expira_em DATETIME,
  ativo BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (user_id) REFERENCES usuarios(id)
);

use grupo_bikemia;

CREATE TABLE avaliacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    nota INT NOT NULL CHECK (nota >= 1 AND nota <= 5), -- Nota de 1 a 5 estrelas/pontos
    comentario TEXT,
    data_avaliacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE SET NULL -- Se o usuário for deletado, a avaliação permanece, mas o id_usuario fica nulo.
                                                                       -- Considere ON DELETE CASCADE se preferir que a avaliação seja deletada junto com o usuário.
);

SELECT * FROM avaliacoes;


select * from usuarios;
CREATE TABLE produtos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  descricao TEXT,
  preco DECIMAL(10,2) NOT NULL,
  imagem VARCHAR(255) NOT NULL
);

CREATE TABLE pedidos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id INT, -- se tiver login
  data DATETIME DEFAULT CURRENT_TIMESTAMP,
  total DECIMAL(10,2) NOT NULL
);

CREATE TABLE pedido_itens (
  id INT AUTO_INCREMENT PRIMARY KEY,
  pedido_id INT NOT NULL,
  produto_id INT NOT NULL,
  quantidade INT NOT NULL,
  preco_unitario DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
  FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

INSERT INTO produtos (nome, descricao, preco, imagem) VALUES
('Camisa Oficial Bikemia', 'Camisa de ciclismo oficial do grupo Bikemia, tecido dry-fit, várias cores.', 99.90, 'src/images/Camisa_oficial.png'),
('Camisa Bikemia Azul', 'Camisa de ciclismo azul, confortável e estilosa.', 79.90, 'src/images/camisa2.jpg'),
('Camisa Bikemia Preta', 'Camisa preta para ciclismo, tecido respirável.', 79.90, 'src/images/camisa3.jpg'),
('Boné Bikemia', 'Boné oficial do grupo Bikemia, ajustável.', 39.90, 'src/images/bone_bikemia.jpg'),
('Garrafa Squeeze Bikemia', 'Squeeze de 600ml personalizado do grupo.', 24.90, 'src/images/squeeze_bikemia.jpg'),
('Meia de Ciclismo Bikemia', 'Meia esportiva para ciclismo, tamanho único.', 19.90, 'src/images/meia_bikemia.jpg');
show tables;
SELECT * FROM pedidos;
SELECT * FROM pedido_itens;
SELECT * FROM sessoes;
SELECT * FROM sessoes WHERE token = 'SEU_TOKEN_AQUI' AND ativo = 1 AND expira_em > NOW();
