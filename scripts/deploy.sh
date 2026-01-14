#!/bin/bash

# Configuration de base
COLOR=${COLOR:-blue}

# --- LOGIQUE DES PORTS ---
if [ "$COLOR" == "blue" ]; then
    HOST_PORT=3001
else
    HOST_PORT=3002
fi

echo "Lancement du deploiement : Cible $COLOR sur le port hote $HOST_PORT"

# 1. Pull de la derniere image
docker pull melvyn92/app:latest

# 2. Demarrage du conteneur
docker compose -f docker/docker-compose.yml up -d --pull always $COLOR

# 3. Attente (Augmentee a 60s pour laisser le temps a Prisma/Node de demarrer)
echo "Attente du demarrage de la version $COLOR (60s)..."
sleep 60

# 4. Verification de sante (Utilisation de 127.0.0.1 plus fiable que localhost sur CI)
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
    
    # --- DEBUG : AFFICHER LES LOGS AVANT DE TUER LE CONTENEUR ---
    echo "Voici les logs du conteneur pour comprendre l'erreur :"
    docker compose -f docker/docker-compose.yml logs $COLOR
    # ------------------------------------------------------------

    # On arrete le conteneur qui vient d'echouer
    docker compose -f docker/docker-compose.yml stop $COLOR
    exit 1
fi
