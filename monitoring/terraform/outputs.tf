output "monitoring_server_public_ip" {
  description = "Public IP of the monitoring server"
  value       = aws_eip.monitoring.public_ip
}

output "webserver_public_ip" {
  description = "Public IP of the web server"
  value       = aws_eip.webserver.public_ip
}

output "webserver_private_ip" {
  description = "Private IP of the web server (used by Prometheus)"
  value       = aws_instance.webserver.private_ip
}

output "grafana_url" {
  description = "Grafana URL"
  value       = "http://${aws_eip.monitoring.public_ip}:3000"
}

output "prometheus_url" {
  description = "Prometheus URL"
  value       = "http://${aws_eip.monitoring.public_ip}:9090"
}

output "ssh_monitoring" {
  description = "SSH command for monitoring server"
  value       = "ssh -i ${var.private_key_path} ${var.ssh_user}@${aws_eip.monitoring.public_ip}"
}

output "ssh_webserver" {
  description = "SSH command for web server"
  value       = "ssh -i ${var.private_key_path} ${var.ssh_user}@${aws_eip.webserver.public_ip}"
}
