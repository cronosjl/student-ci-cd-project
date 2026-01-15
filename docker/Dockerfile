FROM node:18-bullseye

# Installation des lib système
RUN apt-get update && apt-get install -y openssl python3 make g++ && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 1. On installe les dépendances
COPY app/package*.json ./
RUN npm install

# 2. On copie le code (GRACE AU .dockerignore, on ne copie PAS le node_modules pourri)
COPY app/ .

# 3. Fix du fichier manquant
RUN echo "import { PrismaClient } from '@prisma/client'; const prisma = new PrismaClient(); export default prisma;" > prisma/prisma-client.ts

# 4. On expose le port
EXPOSE 3000

# 5. Variable magique : Désactive le Daemon NX pour éviter les bugs de cache
ENV NX_DAEMON=false

# 6. Démarrage : On force la génération et on lance
CMD sh -c "npx prisma generate && npx nx serve api --host=0.0.0.0 --skip-nx-cache"
