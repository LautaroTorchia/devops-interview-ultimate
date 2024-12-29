# Guía de Resolucion Pipeline CI/CD para Aplicacion Nginx, Ejercicio 3 Prueba Técnica

## Enunciado:

Prueba 3 - CI/CD Dockerizar un nginx con el index.html default. 

Elaborar un pipeline que ante cada cambio realizado sobre el index.html buildee
la nueva imagen y la actualize en la plataforma elegida. (docker-compose,
swarm, kuberenetes, etc.) Para la creacion del CI/CD se puede utilizar cualquier
plataforma (CircleCI, Gitlab, Github, Bitbucket.)
Requisitos y deseables:
La solución al ejercicio debe mostrarnos que usted puede:

Automatizar la parte del proceso de despliegue. usar conceptos de CI para apro-
visionar el software necesario para que los entregables se ejecuten use cualquier

herramienta de CI de su elección para implementar el entregable

## Solución Propuesta

La solución implementa un pipeline CI/CD utilizando **GitHub Actions**. La aplicación es desplegada en una instancia de Google Cloud Platform (GCP) utilizando **Docker Compose** para la gestión del contenedor.

### Detalles del Pipeline

#### 1. **Detección de Cambios**

El pipeline se activa automáticamente ante cambios en los archivos:

- `index.html`
- `Dockerfile`
- `docker-compose.yml`

en la rama `main` del repositorio.

#### 2. **Etapas del Pipeline**

El pipeline está organizado en las siguientes etapas:

##### **a. Lint y Pruebas de Calidad**

- Validación inicial del código para asegurar su consistencia.
- Placeholder configurado para futuras pruebas de calidad del código, la idea seria en un desarrollo real tener esta etapa desarrollada con las pruebas unitarias del codigo

##### **b. Análisis de Seguridad del Contenedor**

- Uso de **Trivy** para realizar un escaneo de seguridad sobre los archivos del proyecto, especialmente sobre los microservicios e Imagenes Docker
- Reporte de vulnerabilidades de alta y crítica severidad, que por ahora solo como comentario analizan las potenciales amenazas del servicio

##### **c. Construcción y Publicación de la Imagen Docker**

- Construcción de una nueva imagen Docker basada en los cambios realizados.
- Publicación de la imagen en Docker Hub con:
  - Un tag específico vinculado al commit.
  - Un tag general `latest` para referencia.

##### **d. Preparación del Entorno de Despliegue**

- Uso de Google Cloud CLI para iniciar la instancia GCP necesaria para el despliegue.
- Aseguramiento de que la VM se encuentra en estado operativo antes de continuar.

##### **e. Despliegue Automático**

- Actualización de la aplicación utilizando **Docker Compose**.
- Revisión y verificación del despliegue.
- Publicación de la URL de acceso a la aplicación directamente en la interfaz de GitHub.

---


## Razón de Diseño del Pipeline

1. **Idempotencia**: Cada etapa es independiente e idempotente, para asegurar su correcto funcionamiento siempre, como tambien mantener las etapas bien definidas.
2. **Seguridad**: Integración de un escaneo de seguridad para garantizar la calidad de las imágenes Docker.
3. **Buenas Practicas**: Buenas practicas para el desarrollo de un pipeline CI/CD separado en etapas, escalable y con ocultamiento de secretos o informacion privilegiada.

---

## Ejecución del Pipeline

1. Realizar cambios en el archivo `index.html` y confirmar los cambios en la rama `main`.
2. GitHub Actions ejecuta automáticamente el pipeline.
3. La aplicación actualizada se despliega en GCP y está disponible en la URL indicada en la interfaz de GitHub.

---

## Consideraciones Finales

La solucion logra resolver el ejercicio planteado, como tambien integrar algunos conceptos como la idempotencia, las etapas de seguridad(DevSecOps) Como tambien la automatizacion en la instalacion y deploy del servicio en un ambiente en GCP

