# Inception - Developer Documentation

## Overview

The Inception infrastructure is built with Docker and Docker Compose.

It contains three mandatory services:

- NGINX
- WordPress with PHP-FPM
- MariaDB

Each service runs in its own container and is built from its own Dockerfile.

The containers communicate through a dedicated Docker network.

## Prerequisites

The project must run inside a virtual machine.

Required tools:

```text
Docker
Docker Compose
Make
Git
```

Check the tools:

```bash
docker --version
docker-compose --version
make --version
git --version
```

## Project Structure

```text
inception/
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── secrets/
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/
        └── wordpress/
            ├── Dockerfile
            ├── conf/
            └── tools/
```

The `srcs` directory contains the Docker infrastructure configuration.

Each mandatory service has its own Dockerfile.

Configuration files are stored in `conf/`.

Initialization scripts are stored in `tools/`.

## Environment and Secrets

Environment variables are configured in:

```text
srcs/.env
```

The project uses variables such as:

```text
DOMAIN_NAME
MYSQL_DATABASE
MYSQL_USER
WP_TITLE
WP_ADMIN_USER
WP_ADMIN_EMAIL
WP_USER
WP_USER_EMAIL
```

Sensitive passwords are stored in:

```text
secrets/
```

The expected secret files are:

```text
secrets/db_password.txt
secrets/db_root_password.txt
secrets/wp_admin_password.txt
secrets/wp_user_password.txt
```

Sensitive information must not be committed to Git.

## Domain Configuration

The project domain is:

```text
hsamira.42.fr
```

It must resolve to the IP address of the virtual machine.

Check the configuration with:

```bash
grep "hsamira.42.fr" /etc/hosts
```

and:

```bash
getent hosts hsamira.42.fr
```

## Build and Start

From the project root:

```bash
cd ~/inception
make
```

The Makefile uses Docker Compose to build the images and start the infrastructure.

The command used by the Makefile is:

```bash
sudo docker-compose -f srcs/docker-compose.yml up -d --build
```

Check the services:

```bash
docker-compose -f srcs/docker-compose.yml ps
```

## Makefile Commands

Build the images and start the project:

```bash
make
```

Stop containers without removing them:

```bash
make stop
```

Start stopped containers:

```bash
make start
```

Stop and remove containers while keeping the volumes:

```bash
make down
```

Clean containers while keeping the volumes and persistent data:

```bash
make clean
```

Remove containers, volumes and locally built project images:

```bash
make fclean
```

Remove everything and rebuild the project:

```bash
make re
```

## Docker Compose Commands

Build the services:

```bash
sudo docker-compose -f srcs/docker-compose.yml build
```

Build and start the services:

```bash
sudo docker-compose -f srcs/docker-compose.yml up -d --build
```

Check the services:

```bash
sudo docker-compose -f srcs/docker-compose.yml ps
```

Stop the services:

```bash
sudo docker-compose -f srcs/docker-compose.yml stop
```

Start stopped services:

```bash
sudo docker-compose -f srcs/docker-compose.yml start
```

Stop and remove the containers while keeping the volumes:

```bash
sudo docker-compose -f srcs/docker-compose.yml down
```

## Docker Network

List Docker networks:

```bash
docker network ls
```

NGINX, WordPress and MariaDB communicate through the dedicated Docker network.

WordPress connects to MariaDB using:

```text
mariadb:3306
```

NGINX connects to PHP-FPM using:

```text
wordpress:9000
```

Docker DNS allows containers to use service names instead of fixed IP addresses.

## Data Persistence

The project uses persistent Docker volumes for:

```text
MariaDB database data
WordPress website files
```

List the volumes:

```bash
docker volume ls
```

Inspect a volume:

```bash
docker volume inspect <volume_name>
```

Persistent project data is stored under:

```text
/home/hsamira/data/
```

Inside the MariaDB container, database data is stored in:

```text
/var/lib/mysql
```

Inside the WordPress container, website files are stored in:

```text
/var/www/html
```

The volumes preserve the WordPress and MariaDB data when containers are stopped, removed or recreated.

## Persistence Test

Modify a WordPress page from:

```text
https://hsamira.42.fr/wp-admin
```

Save the modification.

Stop the project without deleting the volumes:

```bash
make down
```

Reboot the virtual machine:

```bash
sudo reboot
```

After the reboot:

```bash
cd ~/inception
make
```

Open:

```text
https://hsamira.42.fr
```

The previous WordPress modification and MariaDB data should still be present.

Do not use `make fclean` for this test because it removes the Docker volumes.

## Basic Developer Checks

Check containers:

```bash
docker ps
```

Check images:

```bash
docker images
```

Check the Docker network:

```bash
docker network ls
```

Check Docker volumes:

```bash
docker volume ls
```

Check exposed ports:

```bash
docker ps --format "table {{.Names}}\t{{.Ports}}"
```

Only NGINX should expose port 443 externally.

Test HTTPS:

```bash
curl -k https://hsamira.42.fr
```
