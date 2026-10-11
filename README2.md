# Inception
Inception est un projet d’administration système basé sur Docker. Le but est de construire une infrastructure avec trois services séparés dans trois conteneurs : NGINX, WordPress avec PHP-FPM, et MariaDB.
NGINX est le seul point d’entrée depuis l’extérieur et utilise le port 443 avec HTTPS et TLS 1.2 ou 1.3. Il reçoit les requêtes du navigateur. Si une requête nécessite du PHP, NGINX l’envoie à PHP-FPM via FastCGI sur le port 9000.
PHP-FPM exécute le code PHP de WordPress. Pendant cette exécution, WordPress peut envoyer des requêtes SQL à MariaDB via le port 3306 pour lire ou enregistrer des données comme les utilisateurs, articles, pages et commentaires.
Chaque service possède son propre Dockerfile. Les fichiers conf contiennent la configuration des services et les scripts init.sh servent à préparer les services au démarrage puis à lancer leur processus principal.
Docker Compose permet de construire, connecter et démarrer les trois services ensemble. Les conteneurs communiquent sur un réseau Docker dédié appelé inception.
Le projet utilise deux volumes persistants : un pour les données MariaDB et un pour les fichiers WordPress. Les données sont stockées sous /home/hsamira/data/ afin de rester présentes même si les conteneurs sont supprimés puis recréés.
Les variables de configuration sont placées dans .env, tandis que les mots de passe sont stockés dans des fichiers Docker secrets qui ne doivent pas être poussés sur Git.
Enfin, restart: always permet aux conteneurs de redémarrer automatiquement en cas de crash.


<img width="1055" height="1491" alt="inception" src="https://github.com/user-attachments/assets/7b3f7a77-2178-4b76-9495-9ac65ff958d2" />

<img width="1024" height="1536" alt="image" src="https://github.com/user-attachments/assets/987eaf5d-24bb-41cd-9464-28dfa9f08d44" /> 

<img width="1024" height="1536" alt="image" src="https://github.com/user-attachments/assets/0f7f4b90-39b0-438d-b179-3dfad2f90e53" /> 



