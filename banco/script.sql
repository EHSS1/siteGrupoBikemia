-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 19/06/2025 às 01:18
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `grupo_bikemia`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `avaliacoes`
--

CREATE TABLE `avaliacoes` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `nota` int(11) NOT NULL CHECK (`nota` >= 1 and `nota` <= 5),
  `comentario` text DEFAULT NULL,
  `data_avaliacao` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `eventos`
--

CREATE TABLE `eventos` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `data` date NOT NULL,
  `local` varchar(100) DEFAULT NULL,
  `descricao` text DEFAULT NULL,
  `data_criacao` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `inscricoes_trilhas`
--

CREATE TABLE `inscricoes_trilhas` (
  `id` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_trilha` int(11) NOT NULL,
  `data_inscricao` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `newsletter`
--

CREATE TABLE `newsletter` (
  `id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `data_inscricao` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `pedidos`
--

CREATE TABLE `pedidos` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) DEFAULT NULL,
  `data` datetime DEFAULT current_timestamp(),
  `total` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `pedidos`
--

INSERT INTO `pedidos` (`id`, `usuario_id`, `data`, `total`) VALUES
(1, 2, '2025-06-02 22:33:42', 139.80),
(2, 6, '2025-06-02 23:23:32', 264.50),
(3, 7, '2025-06-02 23:33:29', 344.40);

-- --------------------------------------------------------

--
-- Estrutura para tabela `pedido_itens`
--

CREATE TABLE `pedido_itens` (
  `id` int(11) NOT NULL,
  `pedido_id` int(11) NOT NULL,
  `produto_id` int(11) NOT NULL,
  `quantidade` int(11) NOT NULL,
  `preco_unitario` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `pedido_itens`
--

INSERT INTO `pedido_itens` (`id`, `pedido_id`, `produto_id`, `quantidade`, `preco_unitario`) VALUES
(1, 1, 1, 1, 99.90),
(2, 1, 4, 1, 39.90),
(3, 2, 5, 1, 24.90),
(4, 2, 6, 1, 19.90),
(5, 2, 3, 1, 79.90),
(6, 2, 4, 1, 39.90),
(7, 2, 1, 1, 99.90),
(8, 3, 1, 1, 99.90),
(9, 3, 2, 1, 79.90),
(10, 3, 3, 1, 79.90),
(11, 3, 4, 1, 39.90),
(12, 3, 5, 1, 24.90),
(13, 3, 6, 1, 19.90);

-- --------------------------------------------------------

--
-- Estrutura para tabela `produtos`
--

CREATE TABLE `produtos` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `descricao` text DEFAULT NULL,
  `preco` decimal(10,2) NOT NULL,
  `imagem` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `produtos`
--

INSERT INTO `produtos` (`id`, `nome`, `descricao`, `preco`, `imagem`) VALUES
(1, 'Camisa Oficial Bikemia', 'Camisa de ciclismo oficial do grupo Bikemia, tecido dry-fit, várias cores.', 99.90, 'src/images/Camisa_oficial.png'),
(2, 'Camisa Bikemia Azul', 'Camisa de ciclismo azul, confortável e estilosa.', 79.90, 'src/images/camisa2.jpg'),
(3, 'Camisa Bikemia Preta', 'Camisa preta para ciclismo, tecido respirável.', 79.90, 'src/images/camisa3.jpg'),
(4, 'Boné Bikemia', 'Boné oficial do grupo Bikemia, ajustável.', 39.90, 'src/images/bone_oficial.png'),
(5, 'Garrafa Squeeze Bikemia', 'Squeeze de 600ml personalizado do grupo.', 24.90, 'src/images/squeeze_oficial.png'),
(6, 'Meia de Ciclismo Bikemia', 'Meia esportiva para ciclismo, tamanho único.', 19.90, 'src/images/meia_oficial.png');

-- --------------------------------------------------------

--
-- Estrutura para tabela `sessoes`
--

CREATE TABLE `sessoes` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  `criado_em` datetime DEFAULT current_timestamp(),
  `expira_em` datetime DEFAULT NULL,
  `ativo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `sessoes`
--

INSERT INTO `sessoes` (`id`, `user_id`, `token`, `criado_em`, `expira_em`, `ativo`) VALUES
(38, 14, '556734c501f5c659044e8b06e3e55be1068415631fe80f91235c4ddd81a8cc93', '2025-06-03 23:10:06', '2025-06-11 04:10:06', 0),
(39, 14, 'cd29ef837b704b301b88533d99bfd2247ec2ab5e923609993b434da03b85f8e9', '2025-06-03 23:10:23', '2025-06-11 04:10:23', 0),
(40, 1, 'b3f3eef499ffed7c33e771e128a0f836fcbadcfc60d0f6c7a84f6d39c6b40619', '2025-06-03 23:13:18', '2025-06-11 04:13:18', 0),
(41, 2, '5eeecb6f9399fc3c0740ef3000a0a21ce763a9a4f069e82c268513acd824427e', '2025-06-03 23:15:55', '2025-06-11 04:15:55', 0),
(42, 15, '93ca6b9363eeba6666413531bffdbbf84ee58b9291cce7dfc94ba0bc54c4a0b4', '2025-06-03 23:35:05', '2025-06-11 04:35:05', 0),
(43, 2, '381d71b6a3d9dcf324e58dfb69c064fac1e23a8806af6d376ee8ee8b05b2eec7', '2025-06-05 19:38:49', '2025-06-13 00:38:49', 0),
(44, 2, '6f2f0a44e09346564ca5d936da693b3527061956419e8689092179f027812c78', '2025-06-18 19:04:49', '2025-06-26 00:04:49', 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `trilhas`
--

CREATE TABLE `trilhas` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `data` date NOT NULL,
  `dificuldade` varchar(50) DEFAULT NULL,
  `local` varchar(100) DEFAULT NULL,
  `descricao` text DEFAULT NULL,
  `data_criacao` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `apelido` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  `senha` varchar(255) NOT NULL,
  `data_cadastro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `usuarios`
--

INSERT INTO `usuarios` (`id`, `nome`, `apelido`, `email`, `telefone`, `senha`, `data_cadastro`) VALUES
(1, 'Tatiana', 'tati_taliba', 'tatifeitosabsb@gmail.com', '61991343650', '$2y$10$dEMRjKUwslI7aNUCERE5xegj/BdFCVDgcwY.X3rz423bfxls6OGGK', '2025-05-19 23:17:18'),
(2, 'Eduardo Henrique', 'henrique_taliba', 'henriquefloyd@yahoo.com.br', '+5561991343650', '$2y$10$N4FztNCh5zfPP7BJGoIrPunMIu1D7ozORe023SuYf7Z/mWhidgPOa', '2025-05-23 22:09:09'),
(14, 'Teste', 'teste2', 'teste2@hd.com.br', '', '$2y$10$qZjuwKc3U3hxvApAlS3YaeuAR77m8AU5bqjOlM2HFH3Th1r63z5v2', '2025-06-04 02:09:50'),
(15, 'Teste', 'teste', 'teste@teste.com', '', '$2y$10$GFKghEwPiaSQRa80PRJF/efcBgMOLwIv0dOYJIiK8/aEIUB5Fo0AG', '2025-06-04 02:34:36');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `avaliacoes`
--
ALTER TABLE `avaliacoes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Índices de tabela `eventos`
--
ALTER TABLE `eventos`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `inscricoes_trilhas`
--
ALTER TABLE `inscricoes_trilhas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_trilha` (`id_trilha`);

--
-- Índices de tabela `newsletter`
--
ALTER TABLE `newsletter`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `pedido_itens`
--
ALTER TABLE `pedido_itens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pedido_id` (`pedido_id`),
  ADD KEY `produto_id` (`produto_id`);

--
-- Índices de tabela `produtos`
--
ALTER TABLE `produtos`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `sessoes`
--
ALTER TABLE `sessoes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Índices de tabela `trilhas`
--
ALTER TABLE `trilhas`
  ADD PRIMARY KEY (`id`);

--
-- Índices de tabela `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `avaliacoes`
--
ALTER TABLE `avaliacoes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `eventos`
--
ALTER TABLE `eventos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `inscricoes_trilhas`
--
ALTER TABLE `inscricoes_trilhas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `newsletter`
--
ALTER TABLE `newsletter`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de tabela `pedido_itens`
--
ALTER TABLE `pedido_itens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de tabela `produtos`
--
ALTER TABLE `produtos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de tabela `sessoes`
--
ALTER TABLE `sessoes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT de tabela `trilhas`
--
ALTER TABLE `trilhas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `avaliacoes`
--
ALTER TABLE `avaliacoes`
  ADD CONSTRAINT `avaliacoes_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL;

--
-- Restrições para tabelas `inscricoes_trilhas`
--
ALTER TABLE `inscricoes_trilhas`
  ADD CONSTRAINT `inscricoes_trilhas_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `inscricoes_trilhas_ibfk_2` FOREIGN KEY (`id_trilha`) REFERENCES `trilhas` (`id`);

--
-- Restrições para tabelas `pedido_itens`
--
ALTER TABLE `pedido_itens`
  ADD CONSTRAINT `pedido_itens_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`),
  ADD CONSTRAINT `pedido_itens_ibfk_2` FOREIGN KEY (`produto_id`) REFERENCES `produtos` (`id`);

--
-- Restrições para tabelas `sessoes`
--
ALTER TABLE `sessoes`
  ADD CONSTRAINT `sessoes_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `usuarios` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
