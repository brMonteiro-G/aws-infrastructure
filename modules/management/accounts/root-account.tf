resource "aws_organizations_account" "account" {
  name      = var.account_name
  email     = var.email
  role_name = var.role_name
}

output "account_id" {
  value = aws_organizations_account.account.id
}
