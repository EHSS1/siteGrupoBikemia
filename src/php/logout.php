<?php
require_once __DIR__ . '/core/database.php';
$conn = Database::getInstance();
require_once __DIR__ . '/core/security.php';
// Verifica se o método de requisição é POST
header('Content-Type: application/json');

// Inicia a sessão para poder destruí-la
session_start();

// Obtém o token do cabeçalho Authorization
$headers = getallheaders();
$token = $headers['Authorization'] ?? '';

if (!$token) {
  http_response_code(401);
  echo json_encode(['success' => false, 'message' => 'Token não fornecido']);
  exit;
}

try {
  // Invalida o token no banco de dados
  $stmt = $conn->prepare("UPDATE sessoes SET ativo = 0 WHERE token = ?");
  $stmt->execute([$token]);
  
  // Limpa e destrói a sessão PHP
  session_unset();
  session_destroy();
  
  echo json_encode(['success' => true, 'message' => 'Logout efetuado com sucesso']);
  
} catch (Exception $e) {
  http_response_code(500);
  echo json_encode(['success' => false, 'message' => 'Erro ao efetuar logout: ' . $e->getMessage()]);
} finally {
  $conn = null; // Fecha a conexão com o banco
}
