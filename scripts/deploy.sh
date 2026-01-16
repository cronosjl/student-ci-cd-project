#!/bin/bash

# Configuration de base
COLOR=${COLOR:-blue}

# --- LOGIQUE DES PORTS ---
if [ "$COLOR" == "blue" ]; then
    HOST_PORT=3001
else
    HOST_PORT=3002
fi

# IMPORTANT : On exporte la variable pour que docker-compose la voie !
export HOST_PORT
export COLOR

echo "Lancement du deploiement : Cible $COLOR sur le port hote $HOST_PORT"

# 1. Pull de la derniere image
docker pull melvyn92/app:latest

# 2. Demarrage du conteneur
# On passe explicitement les variables d'environnement au cas où
HOST_PORT=$HOST_PORT COLOR=$COLOR docker compose -f docker/docker-compose.yml up -d --pull always $COLOR

# 3. Attente (60s)
echo "Attente du demarrage de la version $COLOR (60s)..."
sleep 60

# 4. Verification de sante
echo "Test de l'URL : http://127.0.0.1:$HOST_PORT/api/articles"

if curl -s -I "http://127.0.0.1:$HOST_PORT/api/articles" | grep -qE "HTTP/1.[01] (200|401)"; then
    echo "Succes : La version $COLOR repond correctement."
    
    # 5. Application des migrations
    echo "Application des migrations DB..."
    docker compose -f docker/docker-compose.yml exec -T $COLOR npx prisma migrate deploy

    echo "Deploiement termine avec succes !"
    exit 0
else
    echo "Echec du deploiement de $COLOR."
    
    # --- DEBUG ---
    echo "Voici les logs du conteneur pour comprendre l'erreur :"
    docker compose -f docker/docker-compose.yml logs $COLOR
    # -------------

    # On arrete le conteneur qui vient d'echouer
    docker compose -f docker/docker-compose.yml stop $COLOR
    exit 1
fi