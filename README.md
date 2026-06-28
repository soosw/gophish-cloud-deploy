# GoPhish Azure2

Infraestructura para desplegar **GoPhish** automáticamente en **Microsoft Azure** utilizando **Terraform** y **Ansible**.

## Características

- Despliegue automatizado de GoPhish en Azure.
- Selección interactiva de la región de despliegue.
- Configuración automática mediante Docker Compose.
- Obtención de las credenciales iniciales de GoPhish al finalizar el despliegue.

---

# Tabla de contenido

- [Requisitos](#requisitos)
- [Estructura del proyecto](#estructura-del-proyecto)
- [Autenticación con Azure](#autenticación-con-azure)
- [Configuración de la suscripción](#configuración-de-la-suscripción)
- [Despliegue con Terraform](#despliegue-con-terraform)
- [Outputs](#outputs)
- [Destrucción de la infraestructura](#destrucción-de-la-infraestructura)
- [Troubleshooting](#troubleshooting)
- [Despliegue con Ansible](#despliegue-con-ansible)
- [Acceso a GoPhish](#acceso-a-gophish)

---

# Requisitos

Antes de comenzar, asegúrate de contar con lo siguiente:

- Azure CLI
- Terraform
- Ansible
- Docker
- Docker Compose
- Una suscripción activa de Microsoft Azure

---

# Estructura del proyecto

```text
gophish-azure2/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
└── ansible/
    ├── files/
    │   └── docker-compose.yml
    └── playbook.yml
```

---

# Autenticación con Azure

Accede a tu cuenta de Azure.

```bash
cd ~/gophish-azure2/terraform

az login
```

Selecciona la cuenta correspondiente (generalmente la opción **1** o simplemente presiona **Enter**).

Verifica que la suscripción sea la correcta.

```bash
az account show
```

---

# Configuración de la suscripción

Es necesario agregar el **Subscription ID** dentro del archivo `main.tf`.

Puedes obtenerlo ejecutando:

```bash
az account show
```

Modifica el proveedor de Azure de la siguiente manera:

```terraform
provider "azurerm" {
  subscription_id = "TU_SUBSCRIPTION_ID"
  features {}
}
```

> **Importante**
>
> Reemplaza `"TU_SUBSCRIPTION_ID"` por el identificador obtenido con `az account show`.

---

# Despliegue con Terraform

## 1. Inicializar Terraform

Descarga las dependencias necesarias.

```bash
terraform init -upgrade
```

Ejecuta nuevamente la inicialización.

```bash
terraform init
```

---

## 2. Validar la configuración

```bash
terraform validate
```

---

## 3. Generar el plan de despliegue

```bash
terraform plan
```

Durante este proceso se solicitará:

- La contraseña de la máquina virtual.
- La región donde deseas desplegar la infraestructura.

### Regiones recomendadas

- South Central US
- Central US
- West US 2
- East US
- East US 2

> **Importante**
>
> Guarda la región seleccionada, ya que será necesaria durante la destrucción de la infraestructura.

---

## 4. Crear la infraestructura

```bash
terraform apply
```

Cuando Terraform solicite confirmación, escribe:

```text
yes
```

> **Nota:** El despliegue suele tardar entre **5 y 10 minutos**.

---

# Outputs

Una vez finalizado el despliegue, Terraform mostrará:

- URL de acceso a GoPhish.
- Usuario administrador.
- Contraseña inicial.
- Dirección IP pública de la máquina virtual.
- Comando SSH para acceder al servidor.

---

# Destrucción de la infraestructura

Para eliminar todos los recursos creados en Azure ejecuta:

```bash
terraform destroy
```

Cuando Terraform lo solicite:

- Ingresa la contraseña de la máquina virtual.
- Especifica la misma región utilizada durante el despliegue.
- Confirma escribiendo:

```text
yes
```

> **Nota:** La destrucción también puede tardar entre **5 y 10 minutos**.

---

# Troubleshooting

## Error del proveedor de Azure

Si durante el despliegue o destrucción aparece un mensaje similar al siguiente:

```text
This is a bug in the provider, which should be reported in the provider's own issue tracker.
```

Es posible que la API de Azure haya dejado recursos en un estado inconsistente.

### Solución

#### Paso 1. Eliminar el grupo de recursos desde Azure

1. Accede al Portal de Azure.
2. Busca el grupo de recursos **gophish-rg**.
3. Selecciónalo.
4. Haz clic en **Eliminar grupo de recursos**.
5. Confirma la eliminación.

Esto evita que permanezcan recursos huérfanos en la suscripción.

---

#### Paso 2. Eliminar el estado local de Terraform

Desde la carpeta `terraform/` ejecuta:

```bash
rm terraform.tfstate terraform.tfstate.backup
```

---

#### Paso 3. Ejecutar nuevamente el despliegue

```bash
terraform apply
```

---

# Despliegue con Ansible

## Ejecución

Desde el directorio raíz del proyecto ejecuta:

```bash
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --ask-pass --ask-become-pass
```

Antes de ejecutar el playbook, modifica el archivo `inventory.ini` con:

- Dirección IP del servidor.
- Usuario remoto.

---

## Troubleshooting

### Si los contenedores no pasan los checks

Conéctate al servidor:

```bash
ssh usuario@IP
```

Después ejecuta:

```bash
cd /opt/gophish

sudo docker-compose down
```

Sal del servidor:

```bash
exit
```

---

### Obtener la contraseña inicial de GoPhish

Dentro de la máquina virtual ejecuta:

```bash
sudo docker logs gophish
```

---

### Verificar el estado de los contenedores

```bash
sudo docker ps
```

---

# Acceso a GoPhish

Una vez finalizado el despliegue, accede desde tu navegador a:

```text
https://<IP>:3333
```

Ejemplo:

```text
https://20.80.110.15:3333
```

---

# Notas

- El primer despliegue puede tardar entre **5 y 10 minutos**.
- Conserva la región seleccionada durante el despliegue para poder ejecutar correctamente `terraform destroy`.
- Si ocurre algún error relacionado con la API de Azure, consulta la sección de **Troubleshooting** antes de volver a desplegar la infraestructura.
