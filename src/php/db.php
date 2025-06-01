<<<<<<< HEAD
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

=======
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

>>>>>>> 6d37e4fd788793a9363fb7b2a757157aa16097dd
