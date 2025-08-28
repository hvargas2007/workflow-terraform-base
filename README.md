
# AWS ROSA Networking - LATAM


Infraestructura de red VPC para el ambiente ROSA (Red Hat OpenShift Service on AWS) en la región LATAM.

## Descripción

Este proyecto implementa una VPC privada en AWS diseñada específicamente para soportar un cluster ROSA, con conectividad a través de Transit Gateway para comunicación con otras VPCs y salida a internet.

## Arquitectura de Red

### VPC (Virtual Private Cloud)
- **CIDR Block**: Configurado mediante variable `vpc_cidr`
- **Región**: us-east-1
- **Zonas de Disponibilidad**: 3 zonas para alta disponibilidad
- **Características**:
  - DNS Hostnames habilitado
  - DNS Support habilitado
  - Sin NAT Gateway (conectividad mediante Transit Gateway)

### Subnets

#### Subnets Privadas
- Distribuidas en 3 zonas de disponibilidad
- Configurables mediante variable `private_subnets`
- Rutas a Transit Gateway para salida a internet

#### Subnets de Base de Datos
- Distribuidas en 3 zonas de disponibilidad
- Configurables mediante variable `database_subnets`
- Aisladas para mayor seguridad

### Transit Gateway
- **ID**: Configurable mediante variable `transit_gateway_id`
- **Propósito**: Proporciona conectividad con otras VPCs y salida a internet
- **Rutas**: 0.0.0.0/0 → Transit Gateway en todas las subnets privadas

## Configuración

### Variables Principales

```hcl
# Identificación del proyecto
vertical = "rosa"
environment = "dev|qa|pre|master"

# Configuración de red
vpc_cidr = "172.25.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

# Subnets privadas
private_subnets = ["172.25.10.0/24", "172.25.11.0/24", "172.25.12.0/24"]

# Subnets de base de datos
database_subnets = ["172.25.20.0/24", "172.25.21.0/24", "172.25.22.0/24"]

# Transit Gateway
transit_gateway_id = "tgw-xxxxxxxxxxxxx"
```

### Archivos de Configuración por Ambiente

Los archivos de configuración se encuentran en la carpeta `env/`:
- `env/dev.terraform.tfvars` - Ambiente de desarrollo
- `env/qa.terraform.tfvars` - Ambiente de QA
- `env/pre.terraform.tfvars` - Ambiente de pre-producción
- `env/master.terraform.tfvars` - Ambiente de producción

## Despliegue

### Prerequisitos
- Terraform >= 1.9
- AWS CLI configurado
- Permisos AWS necesarios (VPC, EC2, Transit Gateway)
- Acceso al repositorio de módulos de Terraform en GitLab

### Comandos de Terraform

```bash
# Inicializar Terraform
terraform init

# Revisar plan según ambiente
terraform plan --var-file=env/dev.terraform.tfvars

# Aplicar cambios
terraform apply --var-file=env/dev.terraform.tfvars

# Destruir infraestructura (con precaución)
terraform destroy --var-file=env/dev.terraform.tfvars
```

## Pipeline CI/CD

El proyecto incluye un pipeline de GitLab CI/CD con las siguientes etapas:

1. **validate**: Valida la sintaxis y formato del código Terraform
2. **security**: Ejecuta análisis de seguridad con tflint y checkov
3. **plan**: Genera el plan de ejecución
4. **apply**: Aplica los cambios (manual, solo en branches autorizados)
5. **destroy**: Destruye la infraestructura (manual, solo en branches autorizados)

### Branches Soportados
- `dev`: Ambiente de desarrollo
- `qa`: Ambiente de QA
- `pre`: Ambiente de pre-producción
- `master`: Ambiente de producción

## Módulos Terraform Utilizados

El proyecto utiliza el módulo interno de VPC:
- **ib-vpc-latam**: Gestión completa de VPC, subnets, route tables y Transit Gateway attachment

## Estructura del Proyecto

```
.
├── env/                   # Archivos de variables por ambiente
│   ├── dev.terraform.tfvars
│   ├── qa.terraform.tfvars
│   ├── pre.terraform.tfvars
│   └── master.terraform.tfvars
├── .gitlab-ci.yml        # Pipeline CI/CD
├── main.tf              # Configuración principal del módulo VPC
├── provider.tf          # Configuración del proveedor AWS
├── variables.tf         # Definición de variables
└── README.md           # Este archivo
```

## Tags del Proyecto

Todos los recursos están etiquetados con:
- **Project**: Configurado mediante `project_tags`
- **Environment**: dev/qa/pre/master
- **Vertical**: rosa
- **ManagedBy**: Terraform

## Seguridad

### Mejores Prácticas Implementadas
- No hay subnets públicas ni Internet Gateway directo
- Conectividad controlada a través de Transit Gateway
- Aislamiento de red entre subnets privadas y de base de datos
- DNS habilitado para resolución interna

## Soporte

Para soporte o preguntas sobre este proyecto, contactar al equipo de Infraestructura LATAM.