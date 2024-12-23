FROM python:3.9-slim

WORKDIR /app

# Instalamos dependencias para Postgres y nc para el entrypoint.sh
RUN apt update && apt install -y netcat-openbsd gcc libpq-dev

# Instalamos dependencias de la app
COPY config/dev/requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt

# Copiamos el resto del codigo fuente
COPY src/ /app/src
COPY config/dev/entrypoint.sh /app/config/

# Preparamos el script para su ejecucion
RUN chmod +x /app/config/entrypoint.sh

# Preparamos el puerto y el directorio base del Microservicio
EXPOSE 8000
WORKDIR /app/src

ENTRYPOINT [ "/app/config/entrypoint.sh" ] 
