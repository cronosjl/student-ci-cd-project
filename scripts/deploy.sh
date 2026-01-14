#!/bin/bash

# Configuration de base
COLOR=${COLOR:-blue}

# --- LOGIQUE DES PORTS ---
# Si on deploie BLUE, on verifie le port 3001
# Si on deploie GREEN, on verifie le port 3002
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

# 3. Attente pour s'assurer que le service est pret
echo "Attente du demarrage de la version $COLOR (30s)..."
sleep 30

# 4. Verification de sante (curl) sur le BON PORT (HOST_PORT)
echo "Test de l'URL : http://localhost:$HOST_PORT/api/articles"

if curl -s -I "http://localhost:$HOST_PORT/api/articles" | grep -qE "HTTP/1.[01] (200|401)"; then
    echo "Succes : La version $COLOR repond correctement sur le port $HOST_PORT."
    
    # 5. Application des migrations
    echo "Application des migrations DB..."
    docker compose -f docker/docker-compose.yml exec -T $COLOR npx prisma migrate deploy

    echo "Deploiement termine avec succes !"
    exit 0
else
    echo "Echec du deploiement de $COLOR (Le curl a echoue sur le port $HOST_PORT)."
    # On arrete le conteneur qui vient d'echouer
    docker compose -f docker/docker-compose.yml stop $COLOR
    exit 1
fi
