FROM node:18-bullseye

# Installation des lib système
RUN apt-get update && apt-get install -y openssl python3 make g++ && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 1. On copie TOUT (même le mauvais node_modules s'il traîne)
COPY app/ .

# 2. --- LE BULLDOZER ---
# On supprime violemment le dossier node_modules copié pour être sûr de partir de zéro
RUN rm -rf node_modules dist .nx

# 3. Installation PROPRE (Clean Install)
# On force l'installation propre
RUN npm install

# 4. Fix du fichier manquant
RUN echo "import { PrismaClient } from '@prisma/client'; const prisma = new PrismaClient(); export default prisma;" > prisma/prisma-client.ts

# 5. Génération Prisma (Avec les types frais)
RUN npx prisma generate

# 6. Exposition
EXPOSE 3000

# 7. Variable pour désactiver le cache NX
ENV NX_DAEMON=false

# 8. Démarrage
CMD sh -c "npx prisma generate && npx nx serve api --host=0.0.0.0 --skip-nx-cache"
