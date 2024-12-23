resource "aws_organizations_organization" "this" {
  feature_set = var.feature_set
}

resource "aws_organizations_policy" "admin_scp" {
  name   = "AdminAccessPolicy"
  type   = "SERVICE_CONTROL_POLICY"
  content = file("${path.module}/../policies/scp-admin.json")
}

resource "aws_organizations_policy" "restrict_scp" {
  name   = "RestrictPolicy"
  type   = "SERVICE_CONTROL_POLICY"
  content = file("${path.module}/../policies/scp-restrict.json")
}

output "organization_id" {
  value = aws_organizations_organization.this.id
}

output "admin_scp_id" {
  value = aws_organizations_policy.admin_scp.id
}

output "restrict_scp_id" {
  value = aws_organizations_policy.restrict_scp.id
}
