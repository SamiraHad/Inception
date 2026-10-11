*This project has been created as part of the 42 curriculum by hsamira.*

# Inception

## Description

Inception is a system administration project based on Docker.

The goal of this project is to create a small infrastructure composed of several services running in separate Docker containers.

The mandatory services are:

- NGINX with HTTPS using TLS 1.2 and TLS 1.3
- WordPress with PHP-FPM
- MariaDB

Each service runs in its own dedicated container.

The general architecture is:

```text
Browser
   |
   | HTTPS / 443
   v
NGINX
   |
   | FastCGI
   v
WordPress + PHP-FPM
   |
   | SQL / 3306
   v
MariaDB
```

Docker Compose is used to build, connect and manage the services.

The project also uses:

- a dedicated Docker network
- persistent Docker volumes
- environment variables
- Docker secrets

### Project Sources

The project contains custom Dockerfiles, configuration files and initialization scripts for each mandatory service.

The main source files are located in:

```text
srcs/
```

The Docker Compose configuration is located in:

```text
srcs/docker-compose.yml
```

Each service has its own directory under:

```text
srcs/requirements/
```

The project structure is organized as follows:

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
        ├── nginx/
        └── wordpress/
```

### Virtual Machines vs Docker

A virtual machine runs a complete operating system with its own kernel and virtualized hardware.

Docker containers share the host kernel while isolating applications and their dependencies.

Virtual machines are generally heavier and require more resources.

Docker containers are lighter and usually start faster.

For this project, Docker runs inside a virtual machine.

### Secrets vs Environment Variables

Environment variables are used for general configuration values such as:

```text
DOMAIN_NAME
MYSQL_DATABASE
MYSQL_USER
WP_TITLE
```

Docker secrets are used for sensitive information such as passwords.

Inside the containers, secrets are available under:

```text
/run/secrets/
```

Sensitive credentials must not be committed to Git.

### Docker Network vs Host Network

A Docker network creates an isolated network where containers can communicate using their service names.

For example:

```text
nginx -> wordpress:9000
wordpress -> mariadb:3306
```

Host networking would make a container directly use the host machine network.

This project uses a dedicated Docker network and does not use host networking.

### Docker Volumes vs Bind Mounts

Docker volumes are managed by Docker and are used to persist data.

Bind mounts directly map a host path to a path inside a container.

This project uses named Docker volumes for:

- MariaDB database data
- WordPress website files

Persistent project data is stored under:

```text
/home/hsamira/data/
```

The volumes allow the data to remain available when containers are stopped, removed or recreated.

## Instructions

### Build and Start

From the root of the repository:

```bash
make
```

This builds the Docker images and starts the infrastructure.

Check the services:

```bash
docker-compose -f srcs/docker-compose.yml ps
```

The expected services are:

```text
nginx
wordpress
mariadb
```

### Stop and Restart

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

Clean containers while keeping persistent volumes:

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

### Access the Website

The WordPress website is available at:

```text
https://hsamira.42.fr
```

The WordPress administration panel is available at:

```text
https://hsamira.42.fr/wp-admin
```

NGINX is the only external entry point and exposes port 443.

Because the project uses a self-signed TLS certificate, the browser may display a security warning.

### Basic Checks

Check running containers:

```bash
docker ps
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

Check Docker networks:

```bash
docker network ls
```

Check Docker volumes:

```bash
docker volume ls
```

Inspect a volume:

```bash
docker volume inspect <volume_name>
```

Check service logs:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

## Resources

Resources used during the project:

- Docker documentation
- Docker Compose documentation
- Debian documentation
- NGINX documentation
- MariaDB documentation
- WordPress documentation
- PHP-FPM documentation
- WP-CLI documentation

### AI Usage

AI was used as a learning and support tool during the project.

It was used to:

- understand Docker images and containers
- understand Docker Compose
- understand Docker networks
- understand Docker volumes
- understand Docker secrets
- understand NGINX
- understand HTTPS and TLS
- understand PHP-FPM
- understand WordPress
- understand MariaDB
- understand communication between containers
- analyze configuration errors
- review Docker and Linux commands
- review configuration files
- prepare and review project documentation

All AI-generated explanations, commands and suggestions were reviewed, tested and understood before being used in the project.
