# HelloWorld GKE Project

Este proyecto es una solución moderna y completa para desplegar aplicaciones en la nube de Google (GKE). Está diseñado siguiendo las mejores prácticas de la industria, automatizando no solo el despliegue, sino también la seguridad, el monitoreo y la gestión de infraestructura.

---

## Guía de Inicio Rápido

Sigue estos pasos para poner en marcha todo el ecosistema.

### 1. Prerrequisitos Críticos
Antes de empezar, asegúrate de tener:
*   **Cuenta de Google Cloud (GCP)** con facturación activa.
*   **Bucket de Almacenamiento**: Debes crear un bucket en Cloud Storage manualmente (ej. `gs://mi-terraform-state-bucket`) para guardar el estado de la infraestructura.
*   **Cuenta de Servicio (Service Account)**: Una identidad en GCP con permisos de Administrador (`Owner` o equivalente) para que GitHub pueda crear recursos por ti.

### 2. Configuración en GitHub
Ve a la configuración de tu repositorio (`Settings -> Secrets and variables`) y añade:

**Secretos (Información Sensible):**
*   `GCP_CREDENTIALS`: El archivo JSON de tu Service Account (Identity).

**Variables de Entorno:**
| Variable | Descripción |
|:---|:---|
| `GCP_PROJECT_ID` | El ID único de tu proyecto GCP. |
| `GCP_REGION` / `GCP_ZONE` | Ubicación física de los servidores (ej. `us-central1`). |
| `GCP_CLUSTER_NAME` | Nombre para tu clúster de Kubernetes. |
| `GCP_REPO_NAME` | Nombre para tu repositorio de imágenes Docker. |
| `GCP_SA_EMAIL` | Email de la Service Account que usarán tus servidores. |

### 3. Crear Infraestructura (Paso a Paso)
1. Ve a la pestaña **Actions** en GitHub.
2. Ejecuta el flujo **"Infra Manager"** con la opción `apply`.
3. Esto construirá automáticamente tu "Centro de Datos Virtual" (Redes, Servidores, Balanceadores) en unos 10 minutos.

### 4. Desplegar Aplicación
1. Ejecuta el flujo **"Deploy App"**.
2. El sistema compilará tu código Java, lo empaquetará de forma segura y lo lanzará a los servidores recién creados.

---

## Características del Proyecto

### 1. Infraestructura como Código (IaC)
En lugar de crear servidores manualmente haciendo clics, definimos todo nuestro entorno mediante código (`/iac`). Esto nos permite:
*   **Replicar** el entorno exacto en minutos.
*   **Auditar** quién cambió qué configuración.
*   **Prevenir errores humanos** en la configuración de redes y seguridad.

### 2. Automatización Continua (CI/CD)
Utilizamos "robots" (GitHub Actions) que trabajan por nosotros:
*   **Deploy App**: Cada vez que actualizas el código, este robot se encarga de testearlo, empaquetarlo y actualizar la aplicación en vivo sin interrupciones.
*   **Infra Manager**: Un asistente dedicado exclusivamente a mantener la infraestructura de la nube actualizada y sana.

### 3. Seguridad Avanzada (DevSecOps)
La seguridad no es un añadido, es la base del proyecto:
*   **Análisis de Código (CodeQL)**: Escaneamos automáticamente el código fuente en busca de vulnerabilidades lógicas o puertas traseras antes de aceptar cualquier cambio.
*   **Revisión de Dependencias**: Verificamos que las librerías externas que usamos no tengan agujeros de seguridad conocidos (CVEs). Si una librería es peligrosa, el sistema bloquea el cambio.
*   **Permisos Mínimos**: Los servidores tienen estrictamente los permisos necesarios para funcionar (ej. solo leer imágenes), limitando el daño en caso de un ataque.

### 4. Monitoreo y Observabilidad
No volamos a ciegas. La aplicación está instrumentada para reportar su estado en tiempo real a **Google Cloud Logging**:
*   **Logs Inteligentes**: Los registros no son simple texto, son datos estructurados (JSON).
*   **Qué puedes ver**:
    *   Si hay errores, aparecen marcados en rojo automáticamente.
    *   Puedes rastrear una petición específica de un usuario a través de todo el sistema usando su `traceId`.
    *   Gráficas de salud y rendimiento accesibles desde la consola de GCP.

---

## Estructura Técnica (Para Curiosos)

*   `/iac`: Código Terraform (Planos de construcción de la nube).
*   `/.github/workflows`: Instrucciones para los robots de automatización.
*   `/k8s`: Configuraciones de Kubernetes (Cómo debe comportarse la aplicación).
*   `/src`: Código fuente Java de la aplicación.
