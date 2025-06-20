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
  source                         = "terraform-aws-modules/eks/aws"
  cluster_name                   = "my-eks-cluster"
  cluster_version                = "1.29"
  cluster_endpoint_public_access = true
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets

  eks_managed_node_groups = {
    nodes = {
      min_size       = 1
      max_size       = 3
      desired_size   = 2
      instance_types = var.instance_types
    }
  }
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}