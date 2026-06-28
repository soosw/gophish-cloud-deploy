variable "location" { 
	description = "Región de Azure donde se desplegarán los recursos." 
	type        = string 
	default     = "East US" 
}

variable "resource_group_name" { 
	description = "Nombre para el grupo de recursos que contendrá todo." 
	type        = string 
	default     = "gophish-rg" 
}

variable "admin_username" { 
	description = "Nombre de usuario para el administrador de la VM." 
	type        = string 
	default     = "azureuser"
} 

variable "admin_password" { 
	description = "Contraseña para el administrador de la VM. Debe ser compleja." 
	type        = string 
	sensitive   = true 
} 