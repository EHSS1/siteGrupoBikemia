<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nome = strip_tags($_POST['nome'] ?? '');
    $email = filter_var($_POST['email'] ?? '', FILTER_VALIDATE_EMAIL);
    $mensagem = strip_tags($_POST['mensagem'] ?? '');

    if ($nome && $email && $mensagem) {
        $to = 'henriquefloyd@yahoo.com.br'; // Troque para seu e-mail real
        $subject = "Contato do site Grupo Bikemia";
        $body = "Nome: $nome\nE-mail: $email\nMensagem:\n$mensagem";
        $headers = "From: $email\r\nReply-To: $email\r\n";

        if (mail($to, $subject, $body, $headers)) {
            echo json_encode(['success' => true]);
        } else {
            echo json_encode(['success' => false, 'error' => 'Erro ao enviar e-mail.']);
        }
    } else {
        echo json_encode(['success' => false, 'error' => 'Dados inválidos.']);
    }
    exit;
}
echo json_encode(['success' => false, 'error' => 'Método inválido.']);