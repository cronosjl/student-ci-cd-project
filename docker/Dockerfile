FROM node:18-bullseye

# Installation des dépendances système pour Prisma
RUN apt-get update && apt-get install -y openssl python3 make g++ && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copie du code source
COPY app/ .

# Nettoyage et installation propre pour Linux
RUN rm -rf node_modules package-lock.json dist .nx
RUN npm install

# Génération du client Prisma
RUN npx prisma generate --schema=./prisma/schema.prisma

# Build de l'application (si nécessaire par votre framework)
# RUN npx nx build api

EXPOSE 3000
ENV NODE_ENV=production
ENV NX_DAEMON=false

# Démarrage : Migration de la DB puis lancement du serveur
CMD sh -c "npx prisma migrate deploy --schema=./prisma/schema.prisma && node dist/api/main.js"