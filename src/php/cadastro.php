<?php
header('Content-Type: application/json');
require_once 'conexao.php';

try {
    // Obter e sanitizar dados de entrada
    $nome = htmlspecialchars(trim($_POST['nome'] ?? ''));
    $apelido = htmlspecialchars(trim($_POST['apelido'] ?? ''));
    $email = filter_var(trim($_POST['email'] ?? ''), FILTER_VALIDATE_EMAIL);
    $telefone = preg_replace('/\D/', '', $_POST['telefone'] ?? '');
    $senha = $_POST['senha'] ?? '';

    // Validações
    if (!$nome || !$apelido || !$email || !$senha) {
        throw new Exception('Todos os campos obrigatórios devem ser preenchidos');
    }

    if (strlen($senha) < 8) {
        throw new Exception('A senha deve ter no mínimo 8 caracteres');
    }

    // Verificar se e-mail já existe
    $stmt = $conn->prepare("SELECT id FROM usuarios WHERE email = ?");
    $stmt->execute([$email]);
    if ($stmt->fetch()) {
        throw new Exception('E-mail já cadastrado');
    }

    // Criar hash da senha
    $senhaHash = password_hash($senha, PASSWORD_DEFAULT);

    // Inserir novo usuário
    $stmt = $conn->prepare("INSERT INTO usuarios (nome, apelido, email, telefone, senha) VALUES (?, ?, ?, ?, ?)");
    $stmt->execute([$nome, $apelido, $email, $telefone, $senhaHash]);

    echo json_encode([
        'success' => true,
        'message' => 'Cadastro realizado com sucesso!'
    ]);

} catch (Exception $e) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ]);
}