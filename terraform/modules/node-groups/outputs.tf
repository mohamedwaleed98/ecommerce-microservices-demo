output "system_node_group_name" {
  value = aws_eks_node_group.system.node_group_name
}

output "app_node_group_name" {
  value = aws_eks_node_group.apps.node_group_name
}

output "node_role_arn" {
  value = aws_iam_role.nodes.arn
}