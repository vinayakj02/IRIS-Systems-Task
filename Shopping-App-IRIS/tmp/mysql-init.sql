USE mysql;
UPDATE user SET Password=PASSWORD('mynewpassword') WHERE User='root';
FLUSH PRIVILEGES;