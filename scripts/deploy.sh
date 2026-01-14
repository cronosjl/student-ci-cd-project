#!/bin/bash

# 1. Recuperation de la derniere version du code
echo "Recuperation du code depuis GitHub..."
git pull origin main

# 2. Configuration des ports
BLUE_PORT=3001
GREEN_PORT=3002

# 3. Detection de la version active
if [ "$(docker ps -q -f name=app-blue)" ]; then
    TARGET="green"
    TARGET_PORT=$GREEN_PORT
    OLD="blue"
else
    TARGET="blue"
    TARGET_PORT=$BLUE_PORT
    OLD="green"
fi

echo "Lancement du deploiement Blue/Green : Cible $TARGET sur port $TARGET_PORT"

# 4. Export des variables pour Docker Compose
export COLOR=$TARGET
export APP_PORT=$TARGET_PORT

# Utilisation de --build pour integrer les changements du git pull
docker compose -f docker/docker compose.yml up -d --build

# 5. Verification de sante (Healthcheck)
echo "Attente du demarrage de la version $TARGET (30s)..."
sleep 30

if [ "$(docker ps -q -f name=app-$TARGET)" ]; then
    echo "Version $TARGET en ligne sur le port $TARGET_PORT"
    
    # 6. Switch et Arret de l'ancienne version
    if [ "$(docker ps -q -f name=app-$OLD)" ]; then
        echo "Arret de l'ancienne version $OLD..."
        docker stop app-$OLD
    fi
    echo "Deploiement reussi !"
else
    echo "Echec du deploiement de $TARGET. L'ancienne version $OLD reste active."
    exit 1
fi