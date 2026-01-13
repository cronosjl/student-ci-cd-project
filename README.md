# Documentation Technique - Binôme B (Infrastructure & CD)

Cette documentation détaille la mise en œuvre de la conteneurisation, de la stratégie de déploiement et de la sécurité du projet.

---

## 1. Schéma de l'Architecture CI/CD
Le flux complet suit les étapes suivantes :
1. **Push** du code sur GitHub.
2. Déclenchement de **GitHub Actions** (Tests unitaires, Linting).
3. Connexion au serveur de déploiement.
4. Exécution du script de déploiement **Blue/Green**.



---

## 2. Choix de la Stratégie de Déploiement : Blue/Green
Conformément aux exigences, nous avons implémenté une stratégie **Blue/Green**.

* **Objectif** : Garantir un déploiement sans interruption de service (Zero-Downtime).
* **Fonctionnement** : Le script `scripts/deploy.sh` détecte la version active, déploie la nouvelle version sur un port isolé, vérifie sa santé, puis éteint l'ancienne version.
* **Sécurité** : Permet un rollback instantané en cas d'erreur sur la nouvelle version.

---

## 3. Conteneurisation (Docker & Prisma)
L'application utilise **Prisma ORM** et **Nx**. Le Dockerfile utilise un **Multi-stage build** :

1.  **Stage Builder** : Installation des dépendances et génération du client Prisma.
2.  **Stage Runner** : Image légère (slim) contenant uniquement le nécessaire pour l'exécution, réduisant la surface d'attaque et la taille de l'image.

---

## 4. Guide d'installation et de lancement local (WSL)

### Prérequis
* Docker Desktop installé et configuré avec WSL2.
* Accès au terminal Ubuntu/WSL.

### Étape 1 : Configuration des secrets
Créez un fichier `.env` à la racine du projet (ce fichier est ignoré par Git pour la sécurité) :

```bash
COLOR=blue
APP_PORT=3000
JWT_SECRET=votre_cle_secrete_generee
DATABASE_URL=postgresql://admin:password@db:5432/conduit```
### Étape 2 : Lancement de l'infrastructure
Exécutez la commande suivante pour construire et lancer l'application avec sa base de données PostgreSQL :

```bash
docker-compose -f docker/docker-compose.yml up -d --build```
### Étape 3 : Vérification
Attendez environ 30 secondes (le temps que Prisma applique les migrations) et testez l'API :

```bash
curl -I http://localhost:3000/api/articles```

Note : Si vous recevez un code HTTP 200 ou 401, l'application est opérationnelle.

## 5. Déploiement automatisé

Le script `scripts/deploy.sh` permet de simuler le passage en production de manière totalement automatisée. Il suit un cycle de vie rigoureux pour garantir la stabilité de l'infrastructure :

1.  **Mise à jour du code source** : Exécution d'un `git pull` pour récupérer les derniers commits et les correctifs depuis le dépôt GitHub.
2.  **Détermination de la couleur cible** : Le script analyse quel conteneur (`app-blue` ou `app-green`) est actuellement en ligne pour choisir la cible opposée.
3.  **Construction et lancement** : Build de la nouvelle image Docker pour inclure les changements récents, puis démarrage du conteneur sur son port dédié (3001 pour Blue, 3002 pour Green).
4.  **Vérification de santé** : Le script observe une période d'attente (Healthcheck) pour s'assurer que l'application a correctement initialisé sa connexion à la base de données et que le serveur est prêt à répondre.
5.  **Nettoyage (Basculement)** : Une fois la nouvelle version validée, l'ancien conteneur est arrêté. Cela finalise le basculement du trafic vers la nouvelle version sans interruption pour l'utilisateur.



---

## 6. Sécurité et Maintenance

* **Isolation des environnements** : Chaque déploiement s'exécute dans un conteneur isolé, évitant les conflits de dépendances sur le système hôte.
* **Nettoyage automatique** : Le script inclut des mécanismes pour éviter l'accumulation de conteneurs inactifs, optimisant ainsi les ressources du serveur.
* **Persistance des données** : L'utilisation de volumes Docker (`pgdata`) garantit que les données de la base PostgreSQL ne sont pas perdues lors des basculements entre les versions Blue et Green.
