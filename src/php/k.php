<?php
// Habilitar exibição de erros para depuração
error_reporting(E_ALL);
ini_set('display_errors', 1);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = filter_input(INPUT_POST, 'email', FILTER_VALIDATE_EMAIL);

    if ($email) {
        // Configurações do MySQL
        $host = 'localhost';
        $dbname = 'grupo_bikemia';
        $user = 'root';
        $password = '';

        try {
            // Conexão com o banco de dados MySQL via PDO
            $pdo = new PDO("mysql:host=$host;dbname=$dbname", $user, $password, [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            ]);

            // Inserir o email na tabela de newsletter
            $stmt = $pdo->prepare('INSERT INTO newsletter (email) VALUES (:email)');
            $stmt->bindParam(':email', $email);

            if ($stmt->execute()) {
                // Enviar e-mail de confirmação
                $to = $email;
                $subject = "Confirmação de Inscrição - Grupo Bikemia";
                $message = "Obrigado por se inscrever na nossa newsletter! Em breve você receberá novidades.";
                $headers = "From: no-reply@bikemia.com";

                if (mail($to, $subject, $message, $headers)) {
                    // Redirecionar para a página inicial com mensagem de sucesso
                    header('Location: ../index.html?success=1');
                    exit;
                } else {
                    // Redirecionar para a página inicial com mensagem de erro no envio de e-mail
                    header('Location: ../index.html?error=email');
                    exit;
                }
            } else {
                // Redirecionar para a página inicial com mensagem de erro no banco de dados
                header('Location: ../index.html?error=db');
                exit;
            }
        } catch (PDOException $e) {
            // Exibir mensagem de erro do banco de dados
            echo 'Erro na conexão com o banco de dados: ' . $e->getMessage();
        }
    } else {
        // Redirecionar para a página inicial com mensagem de e-mail inválido
        header('Location: ../index.html?error=invalid_email');
        exit;
    }
} else {
    // Redirecionar para a página inicial se o método não for POST
    header('Location: ../index.html');
    exit;
}
?>