# Workflow Base de Terraform

[![Licencia: MIT](https://img.shields.io/badge/Licencia-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=flat&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=flat&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=flat&logo=githubactions&logoColor=white)](https://github.com/features/actions)

Plantilla de infraestructura Terraform lista para producción para desplegar entornos VPC de AWS con pipelines CI/CD automatizados usando GitHub Actions.

## 📋 Tabla de Contenidos

- [Características](#características)
- [Requisitos Previos](#requisitos-previos)
- [Inicio Rápido](#inicio-rápido)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Configuración](#configuración)
- [Uso](#uso)
- [Pipeline CI/CD](#pipeline-cicd)
- [Seguridad](#seguridad)
- [Contribuir](#contribuir)
- [Licencia](#licencia)
- [Soporte](#soporte)

## ✨ Características

- **Soporte Multi-Ambiente**: Configuraciones separadas para ambientes dev, qa y producción
- **Infraestructura Automatizada**: Configuración completa de VPC con subnets privadas y de base de datos
- **Integración con Transit Gateway**: Soporte para conexiones AWS Transit Gateway
- **Seguridad Primero**: Escaneo de seguridad integrado con Checkov y tflint
- **Gestión de Costos**: Infracost integrado para estimación de costos de infraestructura
- **Pruebas Automatizadas**: Workflows preconfigurados de GitHub Actions para plan/apply/destroy
- **Gestión de Estado**: Configuración de backend remoto con S3 y DynamoDB
- **Diseño Modular**: Módulos de Terraform reutilizables para infraestructura consistente

## 📦 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- [Terraform](https://www.terraform.io/downloads) >= 1.5.0
- [AWS CLI](https://aws.amazon.com/cli/) >= 2.0
- [Git](https://git-scm.com/) >= 2.0
- Cuenta de AWS con permisos apropiados
- Cuenta de GitHub para integración CI/CD

### Permisos AWS Requeridos

Tu usuario/rol IAM de AWS necesita los siguientes permisos:
- Creación y gestión de VPC
- Acceso a bucket S3 (para el estado de Terraform)
- Acceso a tabla DynamoDB (para bloqueo de estado)
- Asunción de rol IAM (para CI/CD)

## 🚀 Inicio Rápido

### 1. Clonar el Repositorio

```bash
git clone https://github.com/tuusuario/workflow-terraform-base.git
cd workflow-terraform-base
```

### 2. Configurar Credenciales AWS

```bash
aws configure
# O usar variables de entorno
export AWS_ACCESS_KEY_ID="tu-access-key"
export AWS_SECRET_ACCESS_KEY="tu-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

### 3. Inicializar Terraform

```bash
terraform init
```

### 4. Configurar tu Ambiente

Edita el archivo `env/main.auto.tfvars` con tus valores específicos:

```hcl
vertical         = "nombre-de-tu-proyecto"
environment      = "dev"
vpc_cidr         = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]
# ... otras configuraciones
```

### 5. Desplegar Infraestructura

```bash
# Revisar el plan
terraform plan

# Aplicar la configuración
terraform apply
```

## 📁 Estructura del Proyecto

```
.
├── .github/
│   └── workflows/
│       ├── tfplan.yml        # Terraform plan en PR
│       ├── tfapply.yml       # Terraform apply al fusionar
│       └── tfdestroy.yml     # Terraform destroy (manual)
├── env/
│   └── main.auto.tfvars      # Variables específicas del ambiente
├── main.tf                   # Configuración principal de Terraform
├── variables.tf              # Definición de variables
├── outputs.tf                # Definición de outputs
├── provider.tf               # Configuración del proveedor
├── backend.tf                # Configuración del backend
└── README.md                 # Este archivo
```

## ⚙️ Configuración

### Configuración del Backend

El estado de Terraform se almacena remotamente en S3. Configura `backend.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "tu-bucket-terraform-state"
    key            = "infrastructure/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```

### Variables de Entorno

Variables clave para configurar en `env/main.auto.tfvars`:

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `vertical` | Nombre del proyecto o vertical de negocio | `"ecommerce"` |
| `environment` | Ambiente de despliegue | `"dev"`, `"qa"`, `"prod"` |
| `vpc_cidr` | Bloque CIDR de la VPC | `"10.0.0.0/16"` |
| `availability_zones` | Lista de zonas de disponibilidad | `["us-east-1a", "us-east-1b"]` |
| `private_subnets` | Bloques CIDR de subnets privadas | `["10.0.1.0/24", "10.0.2.0/24"]` |
| `database_subnets` | Bloques CIDR de subnets de BD | `["10.0.101.0/24", "10.0.102.0/24"]` |
| `attach_to_transit_gateway` | Habilitar conexión Transit Gateway | `true` o `false` |

## 📖 Uso

### Crear un Nuevo Ambiente

1. Crea una nueva rama para tu ambiente:
```bash
git checkout -b feature/nuevo-ambiente
```

2. Modifica los archivos de configuración según necesites

3. Sube los cambios y crea un Pull Request:
```bash
git add .
git commit -m "Agregar configuración de nuevo ambiente"
git push origin feature/nuevo-ambiente
```

4. El pipeline CI/CD ejecutará automáticamente `terraform plan`

5. Después de revisar y fusionar, `terraform apply` se ejecutará automáticamente

### Actualizar Infraestructura

1. Realiza cambios en tu configuración de Terraform
2. Crea un Pull Request
3. Revisa la salida del plan en el PR
4. Fusiona para aplicar los cambios

### Destruir Infraestructura

Para destruir la infraestructura, activa manualmente el workflow de destrucción:

1. Ve a la pestaña Actions en GitHub
2. Selecciona "Terraform Destroy Action"
3. Haz clic en "Run workflow"
4. Confirma el ambiente a destruir

## 🔄 Pipeline CI/CD

### Workflows de GitHub Actions

#### Workflow Plan (`tfplan.yml`)
- **Se activa en**: Pull Request hacia las ramas `dev`, `qa` o `main`
- **Acciones**:
  - Ejecuta verificaciones de seguridad (Checkov, tflint)
  - Ejecuta `terraform plan`
  - Publica resultados del plan como comentario en el PR
  - Estima cambios de costos con Infracost

#### Workflow Apply (`tfapply.yml`)
- **Se activa en**: Fusión hacia las ramas `dev`, `qa` o `main`
- **Acciones**:
  - Ejecuta `terraform apply` con auto-aprobación
  - Actualiza la infraestructura basándose en los cambios fusionados

#### Workflow Destroy (`tfdestroy.yml`)
- **Se activa en**: Dispatch manual del workflow
- **Acciones**:
  - Requiere confirmación manual
  - Ejecuta `terraform destroy` con aprobación

### Configurar Secrets de GitHub

Configura los siguientes secrets en tu repositorio de GitHub:

| Nombre del Secret | Descripción |
|-------------------|-------------|
| `ACCESS_TOKEN` | Token de Acceso Personal de GitHub |
| `USERNAME_GITHUB` | Nombre de usuario de GitHub para acceso a módulos |

Configura las siguientes variables:

| Nombre de Variable | Descripción |
|--------------------|-------------|
| `AWS_ROLE` | ARN del rol IAM de AWS a asumir |
| `AWS_REGION` | Región AWS para el despliegue |
| `AWS_BACKEND` | String de configuración del backend S3 |
| `PROJECT_NAME` | Nombre del proyecto para etiquetado |

## 🔐 Seguridad

### Escaneo de Seguridad

- **Checkov**: Escanea configuraciones erróneas de seguridad
- **tflint**: Valida código Terraform para mejores prácticas
- **AWS IAM**: Usa principios de menor privilegio

### Mejores Prácticas

1. Nunca commits datos sensibles (llaves, contraseñas)
2. Usa AWS Secrets Manager para valores sensibles
3. Habilita el cifrado del archivo de estado
4. Usa cuentas AWS separadas para diferentes ambientes
5. Implementa RBAC apropiado con roles IAM
6. Auditorías y actualizaciones regulares de seguridad

## 👨‍💻 Autor

**Hermes Vargas**  
📧 Email: hermesvargas200720@gmail.com  
🔗 GitHub: [@hvargas2007](https://github.com/hvargas2007)

## 📊 Estado del Proyecto

![Estado de Build](https://img.shields.io/github/workflow/status/tuusuario/workflow-terraform-base/terraform)
![Último Commit](https://img.shields.io/github/last-commit/tuusuario/workflow-terraform-base)
![Contribuidores](https://img.shields.io/github/contributors/tuusuario/workflow-terraform-base)

---

Hecho con ❤️ para toda la comunidad