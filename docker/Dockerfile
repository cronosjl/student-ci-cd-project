# Stage 1: Construction
FROM node:18-bullseye-slim AS builder

# Installation des dépendances système
RUN apt-get update && apt-get install -y openssl python3 make g++ && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# Copie des dépendances
COPY app/package*.json ./
RUN npm install

# Copie du code source
COPY app/ .


# On recrée manuellement le fichier prisma-client.ts pour que TypeScript soit content
RUN echo "import { PrismaClient } from '@prisma/client'; const prisma = new PrismaClient(); export default prisma;" > prisma/prisma-client.ts
# -------------------------------------

# Génération du client Prisma
RUN npx prisma generate

# Stage 2: Image finale (plus légère)
FROM node:18-bullseye-slim

WORKDIR /usr/src/app

# Installation de openssl (requis par Prisma runtime)
RUN apt-get update && apt-get install -y openssl && rm -rf /var/lib/apt/lists/*

# On récupère tout ce qui a été construit dans le stage builder
COPY --from=builder /usr/src/app ./

# On expose le port 3000
EXPOSE 3000

# Commande de démarrage simplifiée
# Note : On a retiré "migrate deploy" d'ici car c'est le script deploy.sh qui le fait.
# Cela permet au conteneur de démarrer plus vite.
CMD ["npx", "nx", "serve", "api", "--host=0.0.0.0"]