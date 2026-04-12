module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "eks" {
  source = "../../modules/eks"

  cluster_name    = "ecommerce-main-eks"
  cluster_version = var.cluster_version
  subnet_ids      = module.vpc.private_subnet_ids
}

module "node_groups" {
  source = "../../modules/node-groups"

  cluster_name      = module.eks.cluster_name
  subnet_ids        = module.vpc.private_subnet_ids
  system_node_group = var.system_node_group
  app_node_group    = var.app_node_group
}