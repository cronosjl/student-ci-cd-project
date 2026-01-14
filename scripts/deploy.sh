#!/bin/bash
set -e

BLUE_PORT=3001
GREEN_PORT=3002

# Détection de la version active
if [ "$(docker ps -q -f name=app-blue)" ]; then
    TARGET="green"
    TARGET_PORT=$GREEN_PORT
    OLD="blue"
else
    TARGET="blue"
    TARGET_PORT=$BLUE_PORT
    OLD="green"
fi

echo "🚀 Déploiement Blue/Green : cible $TARGET sur port $TARGET_PORT"

export COLOR=$TARGET
export APP_PORT=$TARGET_PORT
export DATABASE_URL=${DATABASE_URL:-postgres://test:test@database-realworld:5432/testdb}
export JWT_SECRET=${JWT_SECRET:-supersecret}

# Démarrage de la DB si elle n'est pas déjà active
if [ -z "$(docker ps -q -f name=database-realworld)" ]; then
    echo "⬆️ Démarrage de PostgreSQL..."
    docker compose -f docker/docker-compose.yml up -d database-realworld
    echo "⏳ Attente que la DB soit prête (20s)..."
    sleep 20
fi

# Démarrage de l'app cible
docker compose -f docker/docker-compose.yml up -d --build app-$TARGET

# Attente que l'app soit prête
echo "⏳ Attente du démarrage de la version $TARGET (30s)..."
sleep 30

# Vérification que le container tourne
if [ "$(docker ps -q -f name=app-$TARGET)" ]; then
    echo "✅ Version $TARGET en ligne sur le port $TARGET_PORT"
    
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
