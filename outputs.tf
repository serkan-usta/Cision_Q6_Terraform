output "role_arn" {
  description = "The ARN of the role"
  value       = aws_iam_role.this.arn
}

output "policy_arn" {
  description = "The ARN of the policy"
  value       = aws_iam_policy.this.arn
}

output "group_arn" {
  description = "The ARN of the group"
  value       = aws_iam_group.this.arn
}

output "user_arns" {
  description = "The ARNs of the users"
  value       = aws_iam_user.this.*.arn
}
