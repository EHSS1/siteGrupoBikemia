<!-- C:\xampp\htdocs\GrupoBikemia_Final\bemvindo.php -->

<?php
session_start();
?>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <title>Bem-vindo - Grupo Bikemia</title>
  <link rel="stylesheet" href="src/css/styles.css">
</head>
<body>
  <header>
    <h1>Bem-vindo ao Grupo Bikemia!</h1>
  </header>
  <main>
    <p>Login efetuado com sucesso, <?php echo $_SESSION['usuario'] ?? 'visitante'; ?>!</p>
    <a href="index.html" class="botao">Voltar à página inicial</a>
  </main>
</body>
</html>
