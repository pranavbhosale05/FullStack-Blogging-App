output "cluster_id" {
  value = aws_eks_cluster.mayur.id
}

output "node_group_id" {
  value = aws_eks_node_group.mayur.id
}

output "vpc_id" {
  value = aws_vpc.mayur_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.mayur_subnet[*].id
}
