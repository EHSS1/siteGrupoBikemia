<?php
// Configurações de conexão com o banco de dados
$host = 'localhost';
$user = 'root';
$password = ''; // se você usa senha no XAMPP, coloque aqui
$dbname = 'grupo_bikemia';

// Cria a conexão usando mysqli
$conn = new mysqli($host, $user, $password, $dbname);

// Verifica erros de conexão
if ($conn->connect_error) {
    die(json_encode([
        'success' => false,
        'message' => 'Erro ao conectar ao banco de dados: ' . $conn->connect_error
    ]));
}
?>

