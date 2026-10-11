NAME = inception

# Commande Docker Compose utilisée pour lancer le projet
COMPOSE = sudo docker-compose -f srcs/docker-compose.yml

# Dossier qui contient les fichiers de mots de passe
SECRETS_DIR = secrets

# Cible principale :
# vérifie d'abord que le dossier secrets existe,
# puis construit et démarre les conteneurs
all: check-secrets
	$(COMPOSE) up -d --build

# Vérifie que le dossier secrets existe
# sinon le Makefile s'arrête et demande de lancer "make secrets"
check-secrets:
	@if [ ! -d $(SECRETS_DIR) ]; then \
		echo "Error: Run 'make secrets' first."; \
		exit 1; \
	fi

# Crée le dossier secrets et les fichiers nécessaires
# Les mots de passe doivent être remplis manuellement ensuite
secrets:
	@mkdir -p $(SECRETS_DIR)
	@touch $(SECRETS_DIR)/db_password.txt
	@touch $(SECRETS_DIR)/db_root_password.txt
	@touch $(SECRETS_DIR)/wp_admin_password.txt
	@touch $(SECRETS_DIR)/wp_user_password.txt


# Arrête les conteneurs sans les supprimer
stop:
	$(COMPOSE) stop

# Redémarre les conteneurs déjà créés
start:
	$(COMPOSE) start

# Arrête et supprime les conteneurs
# Les volumes sont conservés
down:
	$(COMPOSE) down

# Nettoie les conteneurs
# Les volumes et les données sont conservés
clean:
	$(COMPOSE) down

# Supprime les conteneurs, les volumes
# et les images construites par le projet
fclean:
	$(COMPOSE) down -v --rmi local

# Supprime tout puis reconstruit le projet
re: fclean all

.PHONY: all stop start down clean fclean re secrets check-secrets
