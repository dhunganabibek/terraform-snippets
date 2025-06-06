output "address" {
  value       = aws_db_instance.mysql.address
  description = "The address of the MySQL database instance"
}

output "port" {
  value       = aws_db_instance.mysql.port
  description = "The port of the MySQL database instance"
}
