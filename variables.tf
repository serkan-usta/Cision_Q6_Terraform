variable "role_name" {
  type        = string
  description = "The name of the role"
}

variable "prefix" {
  type        = string
  description = "Prefix for the role and policy"
  default     = null
}

variable "policy_name" {
  type        = string
  description = "The name of the policy"
}

variable "users" {
  type        = list(string)
  description = "A list of users to add to the group"
}

variable "group_name" {
  type        = string
  description = "The name of the group"
}
