data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

## A role, with no permissions, which can be assumed by users within the same account
## A policy, allowing users / entities to assume the above role,
resource "aws_iam_role" "this" {
  name               = var.prefix != null ? "${var.prefix}-${var.role_name}" : var.role_name
  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  }
  EOF 
}

## A policy, allowing users / entities to assume the above role
resource "aws_iam_policy" "this" {
  name        = var.prefix != null ? "${var.prefix}-${var.policy_name}" : var.policy_name
  description = "Allows users/entities to the assume the prod-ci-role"
  policy      = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "${aws_iam_role.this.arn}"
        }
    ]
  }
  EOF
}

## A group, with the above policy attached
resource "aws_iam_group" "this" {
  name = var.prefix != null ? "${var.prefix}-${var.group_name}" : var.group_name
}

resource "aws_iam_group_policy_attachment" "this" {
  group      = aws_iam_group.this.name
  policy_arn = aws_iam_policy.this.arn
}

## A user, belonging to the above group.
resource "aws_iam_user" "this" {
  count = length(var.users)
  name  = element(var.users, count.index)
}

locals {
  users = [for user in aws_iam_user.this.*.name : user]
}

resource "aws_iam_group_membership" "team" {
  users = local.users
  name  = "group membership for ${var.group_name}"
  group = aws_iam_group.this.name
}
