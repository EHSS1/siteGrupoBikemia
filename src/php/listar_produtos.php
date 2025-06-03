<?php
header('Content-Type: application/json');
$conn = new mysqli('localhost', 'root', '', 'grupo_bikemia');
$res = $conn->query("SELECT * FROM produtos");
$produtos = [];
while($row = $res->fetch_assoc()) $produtos[] = $row;
echo json_encode($produtos);
$conn->close();