output "subnet_ids" {
  description = "List of subnet ids"
  value       = aws_subnet.public.*.id
}

output "public_route_table_ids" {
  description = "List of route tables ids"
  value       = aws_route_table.public.*.id
}