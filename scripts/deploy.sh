#!/bin/bash

# Configuration
COLOR=${COLOR:-blue}
PORT=${APP_PORT:-3000}

echo "Lancement du deploiement : Cible $COLOR sur port $PORT"

# 1. Pull de la derniere image
docker pull melvyn92/app:latest

# 2. Demarrage du nouveau conteneur
docker compose -f docker/docker-compose.yml up -d --pull always $COLOR

# 3. Attente pour s'assurer que le service est pret
echo "Attente du demarrage de la version $COLOR (30s)..."
sleep 30

# 4. Verification de sante (curl)
if curl -s -I "http://localhost:$PORT/api/articles" | grep -qE "HTTP/1.[01] (200|401)"; then
    echo "Succes : La version $COLOR repond correctement."
    
    # 5. Application des migrations de base de donnees
    echo "Application des migrations DB..."
    docker compose -f docker/docker-compose.yml exec -T $COLOR npx prisma migrate deploy

    echo "Deploiement termine avec succes ! (L'ancienne version n'a pas ete touchee)"
    exit 0
else
    echo "Echec du deploiement de $COLOR."
    # On arrete le conteneur qui vient d'echouer
    docker compose -f docker/docker-compose.yml stop $COLOR
    exit 1
fi
