resource "aws_iam_role" "nodes" {
  name = "${var.cluster_name}-nodes"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  role       = aws_iam_role.nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# SYSTEM NODE GROUP
resource "aws_eks_node_group" "system" {
  cluster_name    = var.cluster_name
  node_group_name = var.system_node_group.name
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = var.subnet_ids

  capacity_type  = var.system_node_group.capacity_type
  instance_types = var.system_node_group.instance_types
  ami_type       = var.system_node_group.ami_type   # ✅ FIX

  scaling_config {
    desired_size = var.system_node_group.desired_size
    min_size     = var.system_node_group.min_size
    max_size     = var.system_node_group.max_size
  }
}

# APP NODE GROUP
resource "aws_eks_node_group" "apps" {
  cluster_name    = var.cluster_name
  node_group_name = var.app_node_group.name
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = var.subnet_ids

  capacity_type  = var.app_node_group.capacity_type
  instance_types = var.app_node_group.instance_types
  ami_type       = var.app_node_group.ami_type   # ✅ FIX

  scaling_config {
    desired_size = var.app_node_group.desired_size
    min_size     = var.app_node_group.min_size
    max_size     = var.app_node_group.max_size
  }
}