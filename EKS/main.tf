module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "eks-cluster-vpc"
  cidr = var.vpc_cidr

  azs             = data.aws_availability_zones.azs.names
  public_subnets  = var.pb_subnet_cidrs
  private_subnets = var.pv_subnet_cidrs

  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true


  tags = {
    Name        = "eks-vpc"
    Terraform   = "true"
    Environment = "dev"
  }
  public_subnet_tags = {
    Name = "eks-public-subnet"
  }
  private_subnet_tags = {
    Name = "eks-private-subnet"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3" # Pinned exact version

  # Cluster config
  cluster_name    = "my-eks-cluster"
  cluster_version = "1.29"
  cluster_endpoint_public_access = true # Explicitly enable public access
  
  # Networking
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Node Group
  eks_managed_node_groups = {
    nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2
      instance_types = ["t3.medium"]
      
      # Recommended additional node group settings
      capacity_type = "ON_DEMAND"
      disk_size     = 20
      labels = {
        role = "general"
      }
    }
  }

  # Modern Access Control (updated policy ARN)
  access_entries = {
    admin-user = {
      principal_arn = "arn:aws:iam::097648937889:user/My-Afonso-IAM-User"
      policy_associations = {
        full-access = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}


data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}
