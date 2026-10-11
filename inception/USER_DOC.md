# Inception - User Documentation

## Overview

This project deploys a WordPress website using Docker.

The mandatory services are:

- NGINX: HTTPS entry point
- WordPress with PHP-FPM: website application
- MariaDB: database

Each service runs in its own Docker container.

The website is accessible through NGINX on HTTPS port 443.

## Start the Project

From the root of the repository:

```bash
make
```

This builds the Docker images and starts all containers.

Check that the services are running:

```bash
docker-compose -f srcs/docker-compose.yml ps
```

The following containers should be running:

```text
nginx
wordpress
mariadb
```

## Stop and Restart the Project

Stop the containers without removing them:

```bash
make stop
```

Start stopped containers:

```bash
make start
```

Stop and remove the containers while keeping the volumes:

```bash
make down
```

Clean the containers while keeping the volumes and persistent data:

```bash
make clean
```

Remove containers, volumes and locally built project images:

```bash
make fclean
```

Rebuild the complete project:

```bash
make re
```

Warning: `make fclean` removes the Docker volumes and therefore removes the persistent project data.

## Access the Website

Open:

```text
https://hsamira.42.fr
```

The website must be accessed using HTTPS.

Because the project uses a self-signed TLS certificate, the browser may display a security warning.

## Access the WordPress Administration Panel

Open:

```text
https://hsamira.42.fr/wp-admin
```

Log in using the WordPress administrator credentials configured for the project.

## Credentials

Configuration variables are stored in:

```text
srcs/.env
```

Sensitive passwords are stored locally in:

```text
secrets/
```

The project uses:

```text
secrets/db_password.txt
secrets/db_root_password.txt
secrets/wp_admin_password.txt
secrets/wp_user_password.txt
```

Inside the containers, secrets are available under:

```text
/run/secrets/
```

Passwords and secret files must not be committed to Git.

To change a password, update the corresponding local secret file and recreate the affected service if necessary.

## Basic Checks

Check running containers:

```bash
docker ps
```

Check exposed ports:

```bash
docker ps --format "table {{.Names}}\t{{.Ports}}"
```

Only NGINX should expose port 443 externally.

Test the website:

```bash
curl -k https://hsamira.42.fr
```

Check service logs:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

Check Docker volumes:

```bash
docker volume ls
```

Check the Docker network:

```bash
docker network ls
```
