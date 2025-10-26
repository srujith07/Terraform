# outputs.tf

output "web_server_ip" {
  description = "The public IP of the web server."
  value       = module.web_server.public_ip
}

output "app_server_ip" {
  description = "The public IP of the app server."
  value       = module.app_server.public_ip
}
