output "selection_role_arn" {
  description = "Arn for the backup selection role"
  value       = aws_iam_role.backup_selection_role.arn
}

output "selection_role_name" {
  description = "Backup selection role name"
  value       = aws_iam_role.backup_selection_role.name
}