# Remote backend
terraform {
  backend "s3" {
    bucket         = "aws-terraform-eks-amk"
    key            = "EKS/terraform.tfstate"
    region         = "ap-southeast-2" 
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

# Existing VPC
data "aws_vpc" "existing_vpc" {
  id = "vpc-88aefdef"  # Specify the ID of your existing VPC
}

# Existing subnets
data "aws_subnet" "existing_subnet_1" {
  id = "subnet-23c8f344"  # Replace with your first existing subnet ID
}

data "aws_subnet" "existing_subnet_2" {
  id = "subnet-36f84d6e"  # Replace with your second existing subnet ID
}

data "aws_subnet" "existing_subnet_3" {
  id = "subnet-fc0135b5"  # Replace with your third existing subnet ID
}

# EKS 
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  
  cluster_name    = "my-eks-cluster"
  cluster_version = "1.21"
  
  cluster_endpoint_public_access = true

  vpc_id                   = data.aws_vpc.existing_vpc.id  
  subnet_ids               = [
    data.aws_subnet.existing_subnet_1.id,
    data.aws_subnet.existing_subnet_2.id,
    data.aws_subnet.existing_subnet_3.id
  ]
 
  eks_managed_node_groups = {
    nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t2.small"] 
    }
  }
 
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

# Output the EKS cluster ID
output "eks_cluster_id" {
  value = module.eks.cluster_id
}
