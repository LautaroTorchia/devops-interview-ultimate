FROM node:20-slim

# Configuración general
WORKDIR /app

# Instalación de dependencias
COPY package.json package-lock.json /app/
RUN npm install --legacy-peer-deps

COPY . /app

EXPOSE 3000

# Comando para iniciar el servidor de desarrollo, aprovechando fast-reload para desarrollo
CMD ["npm", "start"]
