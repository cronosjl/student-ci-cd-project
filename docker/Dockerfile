# On utilise une image Node.js solide (Etape unique pour eviter les soucis de copie)
FROM node:18-bullseye

# Installation des dependances systeme requises par Prisma (OpenSSL)
RUN apt-get update && apt-get install -y openssl python3 make g++ && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 1. Copie des fichiers de dependances
COPY app/package*.json ./

# 2. Installation complete des modules
RUN npm install

# 3. Copie de tout le code source
COPY app/ .


# On recree le fichier prisma-client.ts
RUN echo "import { PrismaClient } from '@prisma/client'; const prisma = new PrismaClient(); export default prisma;" > prisma/prisma-client.ts

# 4. GENERATION CRITIQUE DU CLIENT PRISMA
# C'est cette commande qui va lire schema.prisma et injecter les types (Article, User...) dans node_modules
RUN npx prisma generate --schema=./prisma/schema.prisma

# 5. Exposition du port
EXPOSE 3000

# 6. Démarrage de l'application
# On utilise 'exec' pour que les signaux d'arret (docker stop) passent bien
CMD ["npx", "nx", "serve", "api", "--host=0.0.0.0"]