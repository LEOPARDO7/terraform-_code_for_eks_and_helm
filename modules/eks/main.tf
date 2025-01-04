resource "aws_eks_cluster" "eks" {
  name = "Demo_EKS"

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = false
  }

  role_arn = aws_iam_role.cluster.arn
  version  = "1.30"

  vpc_config {
    subnet_ids = module.vpc.public_subnets
    endpoint_public_access = true
    endpoint_private_access = false
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy, module.vpc
  ]
}

resource "aws_iam_role" "cluster" {
  name = "eks-cluster-example"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}


resource "aws_eks_access_entry" "eks_access_entry" {
  for_each       = { for entry in var.iam_access_entries : entry.principal_arn => entry }
  cluster_name  = aws_eks_cluster.eks.name  # ensure that eks cluster is created with name eks
  principal_arn = each.value.principal_arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "eks_policy_association" {
  for_each       = { for entry in var.iam_access_entries : entry.principal_arn => entry }
  cluster_name  = aws_eks_cluster.eks.name # ensure that eks cluster is created with name eks
  policy_arn    = each.value.policy_arn
  principal_arn = each.value.principal_arn

  access_scope {
    type       = "cluster"
  }
}
