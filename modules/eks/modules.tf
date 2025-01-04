module "vpc" {
  source = "/root/terraform_demo/modules/vpc"
}

module "node" {
  source = "/root/terraform_demo/modules/nodegroup"

  clustername = aws_eks_cluster.eks.name 
  private_subnet = module.vpc.private_subnets

}
