output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = data.aws_eks_cluster.cluster.name
}

