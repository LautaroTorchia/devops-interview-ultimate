# Despliegue de Aplicación Django (Backend)

## Estructura del Proyecto

La estructura de carpetas y archivos para el backend es la siguiente:

```
backend/
├── src/                  # Código fuente de la aplicación Django
├── config/
│   ├── dev/              # Configuración para desarrollo
│   │   ├── Dockerfile
│   │   ├── .env
│   │   ├── entrypoint.sh
│   │   ├── requirements.txt
│   ├── prod/             # Configuración para producción
│       ├── Dockerfile
│       ├── .env
│       ├── entrypoint.sh
│       ├── requirements.txt
docker-compose.yml    # docker compose para levantar el stack completo local
```

---
## Instrucciones para desplegar el servicio localmente en desarrollo

1. Crear un archivo `.env` en `backend/config/dev/` con las variables necesarias (puedes usar `.env.postgres` como referencia).

2. Levantar los servicios:

   ```bash
   docker-compose up -d --build
   ```

3. Acceder al backend:

   - La aplicación estará disponible en: [http://localhost:8000](http://localhost:8000)
   - La base de datos PostgreSQL estará corriendo en el puerto `5432`.

---
## Porque de las elecciones de despliegue?

Las elecciones de tener la carpeta `config/` con las configuraciones tanto de `dev/` como de `prod/` es para poder definir claramente 2 configuraciones para el microservicio, la configuracion de desarrollo, que podria contar con *fast-reload*, debugging tools y otras herramientas de desarrollo, y la configuracion de produccion, que sera levantada cuando se productivice la aplicacion o cuando se levante en un ambiente cloud, el cual esta pensado para deployearse no con docker-compose.yml sino con otro formato

-------


# Despliegue de React.js (Frontend)

*Pendiente: Esta sección será completada una vez que el frontend esté configurado.*

---
