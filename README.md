# HelloWorld GKE Project

Proyecto DevOps completo para desplegar una aplicación Spring Boot en Google Kubernetes Engine (GKE) utilizando Terraform y GitHub Actions.

---

## Guía de Inicio Rápido (Paso a Paso)

Sigue estos pasos para levantar todo el proyecto desde cero.

### 1. Prerrequisitos
*   **Cuenta de GCP**: Con facturación activa.
*   **Service Account (GCP)**: Necesitas una cuenta de servicio con permisos de `Owner` (o Editor + Kubernetes Admin + Storage Admin + Artifact Registry Admin). Crea una JSON Key para ella.
*   **GitHub Secrets**: Configura el secret `GCP_CREDENTIALS` con el contenido del JSON de tu Service Account.

### 2. Configuración de Variables (GitHub)
Ve a `Settings -> Secrets and variables -> Actions -> Variables` y configura:

| Variable | Descripción | Ejemplo |
|:---|:---|:---|
| `GCP_PROJECT_ID` | Tu ID de proyecto en GCP | `mi-proyecto-123` |
| `GCP_REGION` | Región para los recursos | `us-central1` |
| `GCP_ZONE` | Zona para el clúster | `us-central1-c` |
| `GCP_CLUSTER_NAME` | Nombre del clúster GKE | `helloworld-cluster` |
| `GCP_REPO_NAME` | Nombre del repositorio Docker | `helloworld-repo` |
| `GCP_SA_EMAIL` | Email de la Service Account de IAM | `terraform-sa@...` |

### 3. Crear Infraestructura
1. Ve a la pestaña **Actions**.
2. Selecciona **Infra Manager** (Workflow de Infraestructura).
3. Ejecuta (`Run workflow`) con la acción: `apply`.
4. *Espera ~10 min:* Esto creará VPC, GKE, y el Ingress Controller (Nginx).

### 4. Desplegar Aplicación
1. Selecciona **Deploy App** (Workflow de Aplicación).
2. Ejecuta (`Run workflow`).
3. *Espera ~2 min:* Esto compila Java, construye Docker y actualiza Kubernetes.

### 5. Acceso
Obtén la IP pública para ver tu "Hello World":
```bash
kubectl get service -n ingress-nginx
# Copia la EXTERNAL-IP y pégala en tu navegador.
```

---

## Estructura y Detalles Técnicos

### 1. Infraestructura como Código (Terraform)
Ubicación: `/iac`

Implementamos una infraestructura inmutable que cumple con el **Punto 1** de los requerimientos:
*   **`vpc.tf`**: Red VPC aislada con rangos secundarios para Pods y Servicios (VPC-Native/Alias IPs).
*   **`gke.tf`**: Clúster Kubernetes zonal optimizado (1 nodo `e2-medium` para dev).
*   **`ingress.tf`**: Despliegue automatizado de **Nginx Ingress Controller** usando Helm y Terraform.
*   **`artifact_registry.tf`**: Repositorio seguro para imágenes Docker.

### 2. Pipeline de CI/CD (GitHub Actions)
Ubicación: `/.github/workflows`

Automatización completa cumpliendo el **Punto 2**:

*   **`infra.yml` ("Infra Manager")**:
    *   Gestiona el ciclo de vida de Terraform.
    *   Permite `Apply` (Crear/Actualizar) y `Destroy` (Eliminar) manualmente.
    *   Inyecta variables de forma segura.

*   **`deploy.yml` ("Deploy App")**:
    *   **CI (Build)**: Compila con Maven y JDK 17. Construye imagen Docker.
    *   **Publish**: Sube la imagen a Artifact Registry etiquetada con SHA.
    *   **CD (Deploy)**: Actualiza los manifiestos de Kubernetes (`k8s/`) inyectando la nueva imagen y aplicando cambios al clúster.

### 3. Seguridad y Permisos
Cumplimiento del **Punto 3**:

*   **Principio de Menor Privilegio (Service Account)**:
    *   Los nodos de GKE **no** usan la cuenta por defecto de Compute Engine. Usan una SA dedicada (`var.service_account_email`).
    *   **Roles IAM**: Se asigna específicamente el rol `roles/artifactregistry.reader` a esta SA.
    *   *Justificación*: Esto asegura que si un contenedor es comprometido, el atacante solo puede "leer" imágenes, pero no puede sobreescribir repositorios, borrar infraestructura ni acceder a otros recursos del proyecto.
*   **Secretos Encriptados**: Las credenciales de administración (`GCP_CREDENTIALS`) viajan cifradas desde GitHub Actions y nunca se escriben en disco.

---

## Manifiestos de Kubernetes
Ubicación: `/k8s`

*   **`00-namespace.yml`**: Espacio de nombres aislado `helloworld`.
*   **`10-deployment.yml`**: Aplicación Java (2 réplicas) con *Probes* de salud configurados para alta disponibilidad.
*   **`20-service.yml`**: Servicio tipo `ClusterIP` interno.
*   **`30-ingress.yml`**: Reglas de enrutamiento para Nginx, exponiendo la app en la raíz `/`.
*   **`40-hpa.yml`**: Autoescalado horizontal basado en uso de CPU/Memoria.
