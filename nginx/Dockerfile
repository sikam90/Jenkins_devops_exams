# Utiliser l'image officielle NGINX
FROM nginx:latest

# Supprimer la config par défaut
RUN rm /etc/nginx/conf.d/default.conf

# Copier la config personnalisée depuis ce dossier
COPY nginx_config.conf /etc/nginx/conf.d/default.conf

# Exposer le port 80
EXPOSE 80

# Lancer NGINX en mode foreground
CMD ["nginx", "-g", "daemon off;"]
