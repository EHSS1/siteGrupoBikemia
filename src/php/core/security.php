<?php
class Security {
    public static function validateRequestMethod(string $method): void {
        if ($_SERVER['REQUEST_METHOD'] !== $method) {
            throw new RuntimeException('Método não permitido', 405);
        }
    }

    public static function validateCSRF(): void {
        $token = $_SERVER['HTTP_X_CSRF_TOKEN'] ?? '';
        if (!hash_equals($_SESSION['csrf_token'] ?? '', $token)) {
            throw new RuntimeException('Token CSRF inválido', 403);
        }
    }

    public static function sanitize(string $input): string {
        return htmlspecialchars(trim($input), ENT_QUOTES, 'UTF-8');
    }

    public static function startSession(array $user): void {
        session_start();
        $_SESSION['user_id'] = $user['id'];
        $_SESSION['user_name'] = $user['nome'];
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
}