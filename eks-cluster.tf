provider "kubernetes" {
#   load_config_file = "false"
  host = data.aws_eks_cluster.myapp-cluster.endpoint
  token = data.aws_eks_cluster_auth.myapp-cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.myapp-cluster.certificate_authority.0.data)
}

data "aws_eks_cluster" "myapp-cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "myapp-cluster" {
  name = module.eks.cluster_id
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.5.1"

  cluster_name    = "myapp-eks-cluster"
  cluster_version = "1.24"

  subnet_ids = module.myapp-vpc.private_subnets
  vpc_id = module.myapp-vpc.vpc_id

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  tags = {
    environment = "development"
    application = "myapp"
  }

  
  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t2.small"]

      min_size     = 1
      max_size     = 1
      desired_size = 1
    }

    two = {
      name = "node-group-2"

      instance_types = ["t3.medium"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }

#   eks_managed_node_groups = [
#     {
#       name = "managed-node-group-1"
#       instance_type = "t2.small"
#       asg_desired_capacity = 2
#     },
#     {
#       name = "managed-node-group-2"
#       instance_type = "t2.medium"
#       asg_desired_capacity = 1
#     }
#   ]
}