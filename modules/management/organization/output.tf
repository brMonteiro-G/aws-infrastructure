# Output the organization ID
output "organization_id" {
  description = "The ID of the AWS Organization."
  value       = aws_organizations_organization.this.id
}

# Output the root organizational unit (OU) ID
output "root_ou_id" {
  description = "The ID of the root organizational unit."
  value       = aws_organizations_organization.this.roots[0].id
}

# Output the IDs of the SCPs
output "admin_scp_id" {
  description = "The ID of the Admin SCP policy."
  value       = aws_organizations_policy.admin_scp.id
}

output "restrict_scp_id" {
  description = "The ID of the Restrict SCP policy."
  value       = aws_organizations_policy.restrict_scp.id
}

# Output IDs of additional organizational units (if created)
output "development_ou_id" {
  description = "The ID of the Development OU."
  value       = aws_organizations_organizational_unit.dev_ou.id
}

output "production_ou_id" {
  description = "The ID of the Production OU."
  value       = aws_organizations_organizational_unit.prod_ou.id
}
