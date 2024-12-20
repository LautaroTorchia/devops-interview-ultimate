FROM python:3.9.16-alpine3.18 AS builder

WORKDIR /app

# Instalar dependencias de compilación necesarias
RUN apk add --no-cache --virtual .build-deps gcc g++ musl-dev libffi-dev \
    postgresql-dev openssl-dev python3-dev py3-pip make

# Crear entorno virtual para aislamiento de dependencias, practica recomendada en Python
RUN python3 -m venv /env

# Instalar dependencias de Python
COPY config/prod/requirements.txt /app/
RUN /env/bin/pip install --no-cache-dir --upgrade pip && \
    /env/bin/pip install --no-cache-dir -r requirements.txt

# Limpiar dependencias de compilación para optimizar tamaño
RUN apk del .build-deps

FROM python:3.9.16-alpine3.18

# Crear un usuario no root para mayor seguridad en el contenedor
RUN addgroup -S django && adduser -S django_user -G django

WORKDIR /app

# Instalar dependencias Para Postgres y nc para el entrypoint
RUN apk add --no-cache libffi postgresql-libs openssl

# Copiar el Virtualenv y código fuente
COPY --from=builder /env /env
COPY src/ /app/src
COPY config/prod/entrypoint.sh /app/config/

# Cambiar permisos de archivos al usuario no root
RUN chown -R django_user:django /app
ENV PATH="/env/bin:$PATH"
ENV PYTHONUNBUFFERED=1

# Preparamos el puerto y el directorio base del Microservicio
WORKDIR /app/src
EXPOSE 8000

# Preparamos el script para su ejecucion
RUN chmod +x /app/config/entrypoint.sh
USER django_user

# Definir el punto de entrada
ENTRYPOINT [ "/app/config/entrypoint.sh" ] 

