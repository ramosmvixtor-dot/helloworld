# Infraestructura GKE Terraform POC

Este proyecto contiene la configuración de Terraform para desplegar un entorno de pruebas en Google Cloud Platform (GCP).

## Recursos Desplegados

- **Red**: VPC (`vpc-gke-main`) y Subnet dedicadas.
- **Compute**: Clúster GKE Zonal con un Node Pool de preemptible VMs.
- **Almacenamiento**: Artifact Registry para imágenes Docker.
- **Aplicaciones**: Nginx Ingress Controller (Instalado vía Helm en el namespace `ingress-nginx`).

## Requisitos Previos

- **Terraform**: v1.0+
- **Cuenta de Servicio (Service Account)**: JSON Key con permisos de Owner o Editor (para POC).

## Configuración y Autenticación

Para evitar el uso de `gcloud` CLI y facilitar la automatización, la autenticación se gestiona mediante variables de entorno.

### Opción Recomendada: Variable de Entorno
Establece la variable `GOOGLE_CREDENTIALS` con el **contenido** de tu archivo JSON de clave de cuenta de servicio.

**En local (bash/zsh):**
```bash
export GOOGLE_CREDENTIALS=$(cat /ruta/a/tu/key.json)
```

**En CI/CD (GitHub Actions, GitLab CI, etc.):**
Guarda el contenido del JSON en una variable secreta y expórtala como variable de entorno.

### Variables de Terraform
El proyecto tiene valores por defecto en `variables.tf`. Para personalizarlos, puedes crear un archivo `terraform.tfvars`:

```hcl
project_id         = "tu-id-de-proyecto"
region             = "us-east1"
gke_cluster_name   = "mi-cluster-gke"
```

## Despliegue

1. **Inicializar y Descargar Proveedores**:
   ```bash
   terraform init
   ```

2. **Revisar Cambios**:
   ```bash
   terraform plan
   ```

3. **Aplicar Infraestructura**:
   ```bash
   terraform apply
   ```

## Estructura del Proyecto

- `providers.tf`: Configuración de proveedores (Google, Helm).
- `vpc.tf`: Definición de red.
- `gke.tf`: Configuración del clúster Kubernetes.
- `registry.tf`: Artifact Registry.
- `ingress.tf`: Configuración de Helm para Nginx Ingress.
- `variables.tf` & `outputs.tf`: Entradas y salidas del módulo.
