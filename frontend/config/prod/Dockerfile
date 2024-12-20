# Etapa de construcción
FROM node:20-alpine as build

# Configuración general
WORKDIR /app

# Instalación de dependencias
COPY package.json package-lock.json /app/
RUN npm install --legacy-peer-deps

# Construcción de la aplicación
COPY . /app
RUN npm run build

FROM nginx:1.25-alpine as production

# Agregar usuario no root, recomendado por seguridad
RUN addgroup -g 1001 react && \
    adduser -u 1001 -G react -h /home/react_user -D react_user

COPY config/prod/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build /usr/share/nginx/html

# Dar permisos al nuevo usuario a las carpetas de nginx
RUN mkdir -p /var/lib/nginx/tmp /var/log/nginx \
    && chown -R react_user:react /var/lib/nginx /var/log/nginx /usr/share/nginx/html \
    && chmod -R 755 /var/lib/nginx /var/log/nginx

RUN touch /var/run/nginx.pid \
    && chown -R react_user:react /var/run/nginx.pid /var/cache/nginx

USER react_user

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
