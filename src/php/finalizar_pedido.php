<?php
header('Content-Type: application/json');
require_once __DIR__ . '/core/database.php';
require_once __DIR__ . '/core/security.php';

// Valide o token recebido no header

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
$usuario_id = null;

file_put_contents('log_token.txt', print_r([
    'headers' => $headers,
    'token' => $token,
    '_SERVER' => $_SERVER
], true));

// Valida o token e obtém o usuário logado (adaptado para buscar na tabela sessoes)
if ($token) {
    $conn = Database::getInstance();
    $stmt = $conn->prepare("SELECT user_id FROM sessoes WHERE token = ? AND ativo = 1 AND expira_em > NOW()");
    $stmt->execute([$token]);
    $row = $stmt->fetch();
    if ($row) {
        $usuario_id = $row['user_id'];
    }
}
if (!$usuario_id) {
    echo json_encode(['success'=>false, 'error'=>'Usuário não autenticado']);
    http_response_code(401);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);

if (
    !isset($data['itens']) || !is_array($data['itens']) || count($data['itens']) === 0 ||
    !isset($data['total'])
) {
    echo json_encode(['success'=>false, 'error'=>'Dados inválidos']);
    http_response_code(400);
    exit;
}

$itens = $data['itens'];
$total = floatval($data['total']);

try {
    // Grava pedido
   $stmt = $conn->prepare("INSERT INTO pedidos (usuario_id, total, data) VALUES (?, ?, NOW())");
    $stmt->execute([$usuario_id, $total]);
    $pedido_id = $conn->lastInsertId();

    // Grava itens do pedido
    $stmt = $conn->prepare("INSERT INTO pedido_itens (pedido_id, produto_id, quantidade, preco_unitario) VALUES (?, ?, ?, ?)");
    foreach($itens as $item) {
        $pid = intval($item['id']);
        $qtd = intval($item['quantidade']);
        $preco = floatval($item['preco']);
        $stmt->execute([$pedido_id, $pid, $qtd, $preco]);
    }

    echo json_encode(['success'=>true, 'pedido_id'=>$pedido_id]);
} catch (Exception $e) {
    echo json_encode(['success'=>false, 'error'=>'Erro ao salvar pedido: '.$e->getMessage()]);
    http_response_code(500);
}