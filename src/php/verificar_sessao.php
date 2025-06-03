<?php
require_once __DIR__ . '/core/database.php';
$conn = Database::getInstance();
require_once __DIR__ . '/core/security.php';
// Verifica se o método de requisição é POST
header('Content-Type: application/json');

$headers = getallheaders();
if (isset($headers['Authorization'])) {
    $token = $headers['Authorization'];
} elseif (isset($_SERVER['HTTP_AUTHORIZATION'])) {
    $token = $_SERVER['HTTP_AUTHORIZATION'];
} elseif (function_exists('apache_request_headers')) {
    $apacheHeaders = apache_request_headers();
    $token = $apacheHeaders['Authorization'] ?? '';
} else {
    $token = '';
}
file_put_contents('log_token.txt', print_r([
    'headers' => $headers,
    'token' => $token,
    '_SERVER' => $_SERVER
], true));

if (!$token) {
  echo json_encode(['success' => false, 'message' => 'Token não fornecido']);
  exit;
}

$stmt = $conn->prepare("SELECT usuarios.* FROM sessoes 
JOIN usuarios ON sessoes.user_id = usuarios.id
WHERE sessoes.token = ? AND sessoes.ativo = 1 AND sessoes.expira_em > NOW()");
$stmt->execute([$token]);

$user = $stmt->fetch();

if ($user) {
  echo json_encode([
    'success' => true,
    'usuario' => [
      'id' => $user['id'],
      'nome' => $user['nome'],
      'apelido' => $user['apelido'],
      'email' => $user['email']
    ]
  ]);
} else {
  echo json_encode(['success' => false, 'message' => 'Sessão inválida ou expirada']);
}
//