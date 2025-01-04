#variable "public_subnets" {
#  description = "List of public subnet IDs"
#  type        = list(string)
#}

variable "iam_access_entries" {
  type = list(object({
    policy_arn     = string
    principal_arn  = string
  }))

  default = [
    {
      policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      principal_arn = "arn:aws:iam::586794447075:role/admin_role"
    }
  ]
}
