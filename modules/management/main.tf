
# Create the AWS Organization
module "organization" {
  source = "./modules/organization"
  feature_set = "ALL"
}

# Root Account
module "root_account" {
  source       = "./accounts"
  account_name = "RootAccount"
  email        = "brgabriel.monteiro@gmail.com"
  role_name    = "OrganizationAccountAccessRole"
}

# Admin Account
module "admin_account" {
  source       = "./accounts"
  account_name = "AdminAccount"
  email        = "admin@example.com"
  role_name    = "AdminAccessRole"
}

# Attach SCPs
resource "aws_organizations_policy_attachment" "admin_scp" {
  policy_id = module.organization.admin_scp_id
  target_id = module.admin_account.account_id
}

resource "aws_organizations_policy_attachment" "restrict_scp" {
  policy_id = module.organization.restrict_scp_id
  target_id = module.root_account.account_id
}
