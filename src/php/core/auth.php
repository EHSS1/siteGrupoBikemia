<<<<<<< HEAD
<?php
session_start();

class Auth {
    public static function generateCSRFToken(): string {
        if (empty($_SESSION['csrf_token'])) {
            $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
        }
        return $_SESSION['csrf_token'];
    }

    public static function validateCSRFToken(string $token): bool {
        return hash_equals($_SESSION['csrf_token'] ?? '', $token);
    }
}
=======
<?php
session_start();

class Auth {
    public static function generateCSRFToken(): string {
        if (empty($_SESSION['csrf_token'])) {
            $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
        }
        return $_SESSION['csrf_token'];
    }

    public static function validateCSRFToken(string $token): bool {
        return hash_equals($_SESSION['csrf_token'] ?? '', $token);
    }
}
>>>>>>> 6d37e4fd788793a9363fb7b2a757157aa16097dd
