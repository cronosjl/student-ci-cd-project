FROM node:18-bullseye

# Installation des outils système nécessaires pour compiler Prisma
RUN apt-get update && apt-get install -y openssl python3 make g++ && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 1. On copie TOUT le dossier 'app' 
# (Cela inclut package.json, prisma/, src/, etc.)
COPY app/ .

# 2. --- LE GRAND NETTOYAGE ---
# On supprime node_modules ET package-lock.json copiés depuis votre PC.
# C'est CRUCIAL pour que Docker installe les versions Linux propres.
RUN rm -rf node_modules package-lock.json dist .nx

# 3. Installation fraîche
# Cela va recréer un node_modules 100% compatible Linux
RUN npm install

# 4. Génération du Client Prisma
# On pointe explicitement vers le schéma qui est maintenant dans /app/prisma/
RUN npx prisma generate --schema=./prisma/schema.prisma

# 5. Fix du fichier manquant (Au cas où il ne serait pas dans votre git)
# Si votre fichier existe déjà, cette ligne l'écrasera avec une version minimale qui marche.
RUN echo "import { PrismaClient } from '@prisma/client'; const prisma = new PrismaClient(); export default prisma;" > prisma/prisma-client.ts

# 6. Exposition du port
EXPOSE 3000

# 7. Variable pour désactiver le cache NX (évite les vieux bugs de build)
ENV NX_DAEMON=false

# 8. Démarrage
# On relance la génération au démarrage par sécurité absolue
CMD sh -c "npx prisma generate --schema=./prisma/schema.prisma && npx nx serve api --host=0.0.0.0 --skip-nx-cache"