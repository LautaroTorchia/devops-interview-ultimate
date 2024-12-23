# Guía de Despliegue para la Aplicación Django y React.js, Ejercicio 2 Prueba Técnica

## Enunciado:

Prueba 2 - Despliegue de una aplicación Django y React.js

Elaborar el deployment dockerizado de una aplicación en Django (backend) con frontend en React.js contenida en el repositorio. Es necesario desplegar todos los servicios en un solo docker-compose.

Se deben entregar los Dockerfiles pertinentes para elaborar el despliegue y justificar la forma en la que elabora el deployment (supervisor, scripts, docker-compose, kubernetes, etc).

Subir todo lo elaborado a un repositorio (GitHub, GitLab, Bitbucket, etc). En el repositorio se debe incluir el código de la aplicación y un archivo README.md con instrucciones detalladas para compilar y desplegar la aplicación, tanto en una PC local como en la nube (AWS o GCP).

---

## Guía:

Esta guía proporciona instrucciones detalladas para desplegar la aplicación con backend en Django y frontend en React.js utilizando tres estrategias diferentes:

1. **Desarrollo Local**: Utilizando `docker-compose-development.yml`, método usual para desarrollo local de desarrolladores.
2. **Pruebas Locales para Producción**: Utilizando `docker-compose-production.yml`. Este entorno se utiliza para probar si el desarrollo local colisiona o genera errores con los microservicios. Es ideal para prepararse antes de subir los servicios a la nube o diferentes ambientes.
3. **Despliegue en Cloud/Kubernetes**: Usando manifiestos de Kubernetes para configuraciones de nivel productivo. El archivo `deploy_stack.sh` sirve como elemento para desplegar toda la infraestructura de una sola vez.

---

## Estructura del Proyecto

La estructura de carpetas y archivos está organizada para mantener una separación clara entre las configuraciones de desarrollo y producción. Los directorios clave son los siguientes:

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
frontend/
├── src/                  # Código fuente de la aplicación React.js
├── config/
│   ├── dev/              # Configuración para desarrollo
│   │   ├── Dockerfile
│   ├── prod/             # Configuración para producción
│       ├── Dockerfile
deployment_files/
├── backend/              # Manifiestos Kubernetes para el backend
├── frontend/             # Manifiestos Kubernetes para el frontend
├── db/                   # Manifiestos Kubernetes para la base de datos
├── ingress/              # Configuraciones de Ingress
├── docker-compose-production.yml # Docker Compose para pruebas locales de producción

docker-compose-development.yml    # Docker Compose para desarrollo local
```

Esta estructura permite un manejo eficiente de entornos, facilitando tanto el desarrollo como el despliegue.

---

## 1. Desarrollo Local

Este entorno está diseñado para facilitar el desarrollo.

### Pasos:

1. **Ejecuta el docker-compose dentro del directorio base**:
   ```bash
   docker-compose -f docker-compose-development.yml up --build # Levanta todos los servicios
   ```

2. **Accede a los servicios**:
   - **Frontend**: `http://localhost:3000`
   - **Backend**: `http://localhost:8000`

3. **Detén el entorno**:
   ```bash
   docker-compose -f docker-compose-development.yml down
   ```

### Notas:
- Dentro de ambos microservicios, `backend/` y `frontend/` en sus carpetas `config/dev/`, están las credenciales y todas las variables de entorno necesarias. Si necesitas modificarlas, edita el archivo `.env.postgres`.

---

## 2. Pruebas Locales para Producción

Este entorno imita el ambiente productivo localmente para pruebas.

### Pasos:

1. **Navega dentro del directorio correcto del proyecto**:
   ```bash
   cd deployment_files
   ```

2. **Ejecuta el entorno productivo**:
   ```bash
   docker-compose -f docker-compose-production.yml up --build # Levanta todos los servicios
   ```

3. **Accede a los servicios**:
   - **Frontend**: `http://localhost`
   - **Backend**: `http://localhost/api`

4. **Detén el entorno**:
   ```bash
   docker-compose -f docker-compose-production.yml down
   ```

### Notas:
- Este entorno utiliza Nginx para servir el frontend y redirigir peticiones al backend. Asegúrate de que el puerto 80 esté disponible.
- Las variables de entorno están definidas en las carpetas `config/prod/`.

---

## 3. Despliegue en Cloud/Kubernetes

Este entorno está diseñado para un despliegue productivo en Kubernetes.

### Estructura de los Manifiestos de Kubernetes:
- **`deployment_files/backend/`**: Manifiestos para el backend (Django).
- **`deployment_files/frontend/`**: Manifiestos para el frontend (React.js).
- **`deployment_files/db/`**: Manifiestos para la base de datos.
- **`deployment_files/ingress/`**: Configuraciones de Ingress.

### Pasos:

1. **Configura los archivos de Kubernetes**:
   - Actualiza los archivos en `deployment_files/` para que coincidan con tu entorno (por ejemplo, credenciales de la base de datos, nombres de host).

2. **Despliega la infraestructura completa (opción recomendada)**:
   ```bash
   bash deployment_files/deploy_stack.sh
   ```

3. **Despliegue manual (opcional)**:
   - **Base de datos**:
     ```bash
     kubectl apply -f deployment_files/db/
     ```
   - **Backend (Django)**:
     ```bash
     kubectl apply -f deployment_files/backend/
     ```
   - **Frontend (React.js)**:
     ```bash
     kubectl apply -f deployment_files/frontend/
     ```
   - **Configuración de Ingress**:
     ```bash
     kubectl apply -f deployment_files/ingress/
     ```

4. **Verifica el despliegue**:
   - Revisa el estado de los pods:
     ```bash
     kubectl get pods
     ```
   - Revisa el estado de los servicios:
     ```bash
     kubectl get services
     ```

5. **Accede a la aplicación**:
   - Configura el DNS o IP externa para el Ingress.

---

### Solución de Problemas

- Utiliza `docker logs` o `kubectl logs` para ver los registros y depurar problemas.
- Si Docker Compose no levanta, revisa los logs para identificar posibles errores en la configuración o el código.

---

## Diseño de los Dockerfiles
La idea de la creacion de Los Dockerfiles, fue crear 2 Dockerfiles para cada microservicio, uno de desarrollo, para garantizar la instalacion de depuradores, debuggers o dependencias de desarrollo en un ambiente mas estable y otro de produccion, optimizado y siguiendo las mejores practicas en optimizacion, algunos de los conceptos usados fueron:

1. **Separación de etapas**:
   - La división entre construcción y ejecución mejora la seguridad al mantener herramientas innecesarias fuera de la imagen final.

2. **Usuarios no root**:
   - Minimiza riesgos en caso de que el contenedor sea comprometido.

3. **Alpine Linux**:
   - Reduce significativamente el tamaño de las imágenes en comparación con distribuciones más completas.

4. **NGINX en producción**:
   - Su capacidad para manejar conexiones concurrentes lo hace ideal para aplicaciones frontend en producción.

---


### Pensamiento Final

La solución planteada permite desplegar los servicios de Backend y Frontend otorgados para la prueba, tanto en entornos locales para el desarrollo como en un ambiente remoto para producción. Tambien realiza Imagenes tanto del Backend como del frontend Optimizadas, ahorrando espacio y utilizando mejores practicas de seguridad

Siguientes pasos que podrían considerarse:
- Certificación SSL y deployment HTTPS.
- Escalabilidad vertical y horizontal de los servicios.
- Ocultamiento e inserción dinámica de secretos.