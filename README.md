# Docker stack setup for general PHP development.

## For PHP 8.1

**For detailed instructions on using this in WSL2 read WSL2SETUP.md**

## Included:
- PHP-FPM image.
- Nginx image for HTTP server.
- PostgreSQL image for DB server.
- RabbitMQ image for messaging queue.
- Mailcatcher image for mail testing.
___

## Prerequisites:
- Docker-CE.
- Docker service running.
- 8 GiB of free Memory.
---

## Initial setup:
1. Create folders:
   1. `/var/www/php_php`
   2. `/var/lib/php_postgres`
2. If You don't have any Docker Swarm node then initialize it with command `docker swarm init`.
___

## Usage:

### Magento code location:
Checkout your magento code in `/var/www/php_php` folder.

### Building images:
Execute `docker/buildImages`.

### Running containers:
Execute `docker/run`. If not working run `bin/runAlt` instead.

### Stopping containers:
Execute `docker/stop`.

### SSH into containers:
Execute `ssh/<target_container>`.

E.g `ssh/php`.

### Executing any cli commands on php container from host
Execute `bin/cli <command>`.

### Checking resource utilization
Execute `docker stats`.

### Notes:
- Code and DB state is persistent as those are stored in `/var/www/php_php` and `/var/lib/php_postgres`.

### Connection info
- PostgreSQL host: localwsl.com
- PostgreSQL port: 5432
- PostgreSQL DB: postgres
- PostgreSQL user: postgres
- PostgreSQL password: qwerty
- RabbitMQ host: rabbitmq
- RabbitMQ port: 5672|15672
- MTA* host: localhost (use for PHP Mail)
- MTA* port: 25 (use for PHP Mail)
- Mailcatcher host: mailcatcher (use for SMTP)
- Mailcatcher port: 1025 (use for SMTP)
- Mailcatcher frontend port: 1080

*MTA - message/mail transfer agent (postfix)

### Xdebug
- port: 9009
- ssh port: 12000
- remote project files path `/var/www/php`
- xdebug tunnel: `ssh -R 9009:127.0.0.1:9009 xdebug@<remote-address> -p 12000`
- ssh xdebug password (for tunnel): `xdebug`