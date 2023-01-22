module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.5.1"

  cluster_name    = "myapp-eks-cluster"
  cluster_version = "1.24"

  subnet_ids = module.myapp-vpc.private_subnets
  vpc_id = module.myapp-vpc.vpc_id

  tags = {
    environment = "development"
    application = "myapp"
  }

  eks_managed_node_groups = {
    dev = {
      min_size     = 1
      max_size     = 3
      desired_size = 3

      instance_types = ["t2.small"]
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