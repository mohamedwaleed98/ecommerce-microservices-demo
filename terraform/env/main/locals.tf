locals {
  project_name = "ecommerce-microservices-demo"
  cluster_name = "ecommerce-main-eks"

  common_tags = {
    Project     = local.project_name
    Environment = "main"
    ManagedBy   = "Terraform"
  }
}