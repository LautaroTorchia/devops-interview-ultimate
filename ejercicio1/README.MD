# Guia de Arquitectura para Aplicación Web Escalable y Alta Disponibilidad, Ejercicio 1 Prueba Técnica

## Enunciado

Prueba 1 - Diagrama de Red: Produzca un diagrama de red (puede utilizar Lucidchart) de una aplicación web en GCP o AWS y escriba una descripción de texto de 1/2 a 1 página de sus elecciones y arquitectura. El diseño debe soportar:

- Cargas variables.
- Contar con HA (alta disponibilidad).
- Frontend en JavaScript.
- Backend con una base de datos relacional y una no relacional.
- La aplicación backend consume 2 microservicios externos.

El diagrama debe hacer un mejor uso de las soluciones distribuidas.

---

## Guía

Este documento describe en detalle el diseño de una arquitectura distribuida para una aplicación web que soporta cargas variables, garantiza alta disponibilidad (HA) y es flexible para cambios futuros. La infraestructura propuesta utiliza Google Cloud Platform (GCP) y está diseñada para ser robusta, segura, eficiente y escalable.

---

## 1. **Visión General del Diagrama**

El diagrama representa:
- Un Load Balancer HTTP(S) para gestionar el tráfico público.
- Kubernetes Engine (GKE) para ejecutar servicios de frontend y backend.
- Bases de datos gestionadas para garantizar rendimiento y HA.
- Redes privadas y firewalls para aislamiento y seguridad.
- Integración con microservicios externos mediante Istio como service mesh y Cloud NAT.
- Monitoreo y logging centralizado mediante Cloud Monitoring y Logging.

### **Componentes Clave del Diagrama**

1. **Dominio y DNS**
   - Configurado en **Cloud DNS** para resolver el dominio.
   - Certificados SSL gestionados por **Cert-Manager**, deployeado internamente en Kubernetes.

2. **Frontend**
   - Contenedores desplegados en GKE.
   - Escalado horizontal automático.

3. **Backend**
   - Contenedores desplegados en GKE.
   - Interactúa con bases de datos y microservicios externos.
   - Escalado horizontal automático.
   - Monitoreo de la comunicación mediante Istio.

4. **Bases de Datos**
   - Relacional: **Cloud SQL** (PostgreSQL).
   - No relacional: **Firestore**.

5. **Balanceo de Carga**
   - **HTTP(S) Load Balancer** para frontend y acceso externo a la infraestructura.
   - **Internal Load Balancer** para comunicación entre frontend y backend.

6. **Seguridad y Redes**
   - Redes privadas (VPC) para aislamiento del backend y las bases de datos.
   - Firewalls configurados para permitir sólo tráfico necesario, configurado desde GCP.

7. **Microservicios Externos**
   - Comunicación segura mediante Istio y Cloud NAT.

8. **Monitoreo y Logging**
   - **Cloud Monitoring** para visualizar métricas clave de infraestructura y servicios.
   - **Cloud Logging** para centralizar logs y configurar alertas personalizadas.

---

## 2. **Razones de las Elecciones**

### **Google Kubernetes Engine (GKE)**
- Proporciona escalabilidad horizontal automática y tolerancia a fallos.
- Rolling updates aseguran despliegues sin tiempo de inactividad.
- Clusters regionales distribuyen nodos en múltiples zonas, garantizando HA.
- Su mantenimiento es mínimo, permitiendo mayor enfoque en el desarrollo.
- La creacion y eliminacion de nodos dentro del cluster es flexible, por lo que es facil de escalar

### **Bases de Datos Gestionadas**
#### **Cloud SQL (PostgreSQL)**
- Reduce la carga operativa al gestionar backups, parches y replicación.
- Garantiza HA mediante replicación regional, la misma replicacion regional que Kubernetes como en el diagrama.
- **Opcional:** Para un enfoque más flexible y menos dependiente del servicio de la nube Host, se podría implementar PostgreSQL en un StatefulSet en GKE, sacrificando simplicidad operativa por independencia de la nube.

### **Balanceo de Carga**
- **HTTP(S) Load Balancer** gestiona tráfico público, distribuye carga globalmente y protege contra ataques DDoS mediante **Cloud Armor**.

### **Istio como Service Mesh**
- Proporciona control detallado de las comunicaciones entre servicios y hacia los microservicios externos.
- Permite observabilidad avanzada, con métricas y trazas distribuidas.
- Aumenta la seguridad mediante autenticación mutua TLS (mTLS).

### **Monitoreo y Logging**
- **Cloud Monitoring** visualiza el rendimiento en tiempo real y ayuda a identificar cuellos de botella.
- **Cloud Logging** centraliza logs, permitiendo depuración eficiente y cumplimiento regulatorio.

---

## 3. **Flujo del Tráfico**

1. El usuario accede al dominio registrado en **Cloud DNS**, que resuelve al Load Balancer HTTP(S).
2. El Load Balancer distribuye las solicitudes al frontend en GKE.
3. El frontend realiza llamadas al backend mediante el Load Balancer interno.
4. El backend interactúa con bases de datos (Cloud SQL y Firestore) y microservicios externos a través de Istio y Cloud NAT.

---

## 4. **Conclusión**

Esta arquitectura garantiza escalabilidad, seguridad y flexibilidad. Tambien es confiable al utilizar muchos mecanismos de la nube para garantizar disponibilidad, Backups y manejo seguro del trafico. Para otro tipo de casos de usos, en donde por ejemplo se tenga que tener especial cuidado de los datos al estar protegidos por la ley, o en otros casos en donde se quiere mantener independencia total del proveedor de la nube, es posible partir de este esquema hacia un esquema 100% independiente sin tener inconvenientes, al estar mayoritariamente basado en Kubernetes como metodo de despliegue y configuracion.

Esta configuracion es capaz de aprovechar lo mejor de ambos mundos, tanto utilizar los servicios y beneficios que proveen los proveedores cloud, como tampoco casarse con uno y poder mantener la independencia tecnologica.

