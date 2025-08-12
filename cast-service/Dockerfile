# Utilise une image officielle Node.js légère
FROM node:18-alpine

# Définit le dossier de travail dans le container
WORKDIR /app

# Copie les fichiers de dépendances et installe les modules
COPY package*.json ./
RUN npm install

# Copie tout le code source
COPY . .

# Expose le port 3000 (ajuste si nécessaire)
EXPOSE 3000

# Commande pour démarrer l'application
CMD ["npm", "start"]
