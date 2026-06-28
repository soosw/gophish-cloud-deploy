output "gophish_panel_url" { 
	description = "URL para acceder al panel de GoPhish (acepta la advertencia de seguridad)." 
	value       = "https://${azurerm_public_ip.pip.ip_address}" 
}
 
output "vm_public_ip" { 
	description = "La dirección IP pública de tu máquina virtual." 
	value       = azurerm_public_ip.pip.ip_address 
}
 
output "ssh_command" { 
	description = "Comando para conectarte a la VM por SSH." 
	value       = "ssh 
${var.admin_username}@${azurerm_public_ip.pip.ip_address}" 
}