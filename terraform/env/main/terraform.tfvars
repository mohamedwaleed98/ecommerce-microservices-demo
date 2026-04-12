aws_region      = "us-east-1"
vpc_cidr        = "10.20.0.0/16"
azs             = ["us-east-1a", "us-east-1b"]
public_subnets  = ["10.20.1.0/24", "10.20.2.0/24"]
private_subnets = ["10.20.11.0/24", "10.20.12.0/24"]

cluster_version = "1.30" # 👈 better than 1.29

system_node_group = {
  name           = "system-ondemand"
  instance_types = ["t3.small"]
  desired_size   = 1
  min_size       = 1
  max_size       = 2
  capacity_type  = "ON_DEMAND"
  ami_type       = "AL2023_x86_64_STANDARD" # ✅ FIX
}

app_node_group = {
  name           = "apps-spot"
  instance_types = ["t3.medium", "t3a.medium"]
  desired_size   = 1
  min_size       = 1
  max_size       = 3
  capacity_type  = "SPOT"
  ami_type       = "AL2023_x86_64_STANDARD" # ✅ FIX
}