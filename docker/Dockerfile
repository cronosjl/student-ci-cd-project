FROM node:18-bullseye

# Installation des lib système
RUN apt-get update && apt-get install -y openssl python3 make g++ && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 1. On copie TOUT le contenu du dossier 'app' local vers le dossier '/app' du conteneur
# Grâce à votre image, on sait que cela inclut 'app/prisma', 'app/package.json', etc.
COPY app/ .

# 2. --- LE NETTOYAGE (Bulldozer) ---
# On supprime le dossier node_modules qui a été copié pour être sûr à 100% de partir propre
RUN rm -rf node_modules dist .nx

# 3. Installation PROPRE des dépendances
RUN npm install

# 4. Création du fichier manquant (Indispensable pour TypeScript)
RUN echo "import { PrismaClient } from '@prisma/client'; const prisma = new PrismaClient(); export default prisma;" > prisma/prisma-client.ts

# 5. Génération Prisma EXPLICITE
# On pointe précisément vers le fichier visible dans votre image
RUN npx prisma generate --schema=./prisma/schema.prisma

# 6. Exposition
EXPOSE 3000

# 7. Optimisation NX
ENV NX_DAEMON=false

# 8. Démarrage
# On relance la génération au démarrage par sécurité, puis on lance l'app
CMD sh -c "npx prisma generate --schema=./prisma/schema.prisma && npx nx serve api --host=0.0.0.0 --skip-nx-cache"
