provider "aws" {
  region = "eu-west-1"
}

module "iam" {
  source      = "../"
  prefix      = "prod"
  role_name   = "ci-role"
  policy_name = "ci-policy"
  group_name  = "ci-group"
  users       = ["user1", "user2"]
}

output "user_arns" {
  value = module.iam.user_arns
}
