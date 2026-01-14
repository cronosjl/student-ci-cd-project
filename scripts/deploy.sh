#!/bin/bash
set -e

# --- 1. Pull du code ---
echo "🔄 Récupération du code depuis GitHub..."
git pull origin main

# --- 2. Configuration des ports ---
BLUE_PORT=3001
GREEN_PORT=3002

# --- 3. Détection de la version active ---
if [ "$(docker ps -q -f name=app-blue)" ]; then
    TARGET="green"
    TARGET_PORT=$GREEN_PORT
    OLD="blue"
else
    TARGET="blue"
    TARGET_PORT=$BLUE_PORT
    OLD="green"
fi

echo "🚀 Lancement du déploiement Blue/Green : Cible $TARGET sur port $TARGET_PORT"

# --- 4. Export des variables pour Docker Compose ---
export COLOR=$TARGET
export APP_PORT=$TARGET_PORT

# --- 5. Démarrage PostgreSQL si besoin ---
docker compose -f docker/docker-compose.yml up -d database-realworld

# --- 6. Vérification de la santé de la DB ---
echo "⏳ Attente que la base de données soit prête (20s)..."
sleep 20

# --- 7. Démarrage de la nouvelle version seulement ---
docker compose -f docker/docker-compose.yml up -d --build app-$TARGET

# --- 8. Attente que l'app soit prête ---
echo "⏳ Attente du démarrage de la version $TARGET (30s)..."
sleep 30

# --- 9. Vérification que le container tourne ---
if [ "$(docker ps -q -f name=app-$TARGET)" ]; then
    echo "✅ Version $TARGET en ligne sur le port $TARGET_PORT"
    
    # 10. Arrêt de l'ancienne version si existante
    if [ "$(docker ps -q -f name=app-$OLD)" ]; then
        echo "🛑 Arrêt de l'ancienne version $OLD..."
        docker stop app-$OLD
        docker rm app-$OLD
    fi
    echo "🎉 Déploiement réussi !"
else
    echo "❌ Échec du déploiement de $TARGET. L'ancienne version $OLD reste active."
    exit 1
fi