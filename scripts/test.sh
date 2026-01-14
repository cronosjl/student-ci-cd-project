#!/bin/bash
set -e

echo "[CI] Demarrage de l'integration continue..."

# 1. Se placer dans le dossier de l'application
cd app

# 2. Installation des dépendances
echo "Installation des modules Node..."
npm ci

# 3. Generation du client Prisma (Crucial pour les tests)
echo "Generation du client Prisma..."
npx prisma generate

# 4. Lancement des tests
echo "Execution des tests unitaires..."

# Note : Le linting est desactive car le script "lint" n'est pas defini dans package.json
# npm run lint

# Lancement des tests
npm test

echo "[CI] Tous les tests sont passes avec succes !"
