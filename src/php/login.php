<?php
session_start();
header('Content-Type: application/json');
require_once 'conexao.php';

try {
    // Verifica se o JSON foi recebido corretamente
    $input = json_decode(file_get_contents('php://input'), true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new Exception('Dados inválidos');
    }

    $usuario = trim($input['usuario'] ?? '');
    $senha = $input['senha'] ?? '';

    if (!$usuario || !$senha) {
        throw new Exception('Usuário e senha são obrigatórios');
    }

    // Verifica credenciais
    $stmt = $conn->prepare("SELECT * FROM usuarios WHERE email = ? OR apelido = ?");
    $stmt->execute([$usuario, $usuario]);
    $user = $stmt->fetch();

    if (!$user || !password_verify($senha, $user['senha'])) {
        throw new Exception('Credenciais inválidas');
    }

    // Cria sessão
    $_SESSION['user_id'] = $user['id'];
    $_SESSION['user_name'] = $user['nome'];

    // Gera token
    $token = bin2hex(random_bytes(32));
    $expira = date('Y-m-d H:i:s', strtotime('+7 days'));

    // Armazena token no banco
    $stmt = $conn->prepare("INSERT INTO sessoes (user_id, token, expira_em) VALUES (?, ?, ?)");
    $stmt->execute([$user['id'], $token, $expira]);

    echo json_encode([
        'success' => true,
        'message' => 'Login realizado com sucesso!',
        'usuario' => [
            'id' => $user['id'],
            'nome' => $user['nome'],
            'apelido' => $user['apelido']
        ],
        'token' => $token
    ]);

} catch (Exception $e) {
    http_response_code(401);
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ]);
}