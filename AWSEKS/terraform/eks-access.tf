data "aws_caller_identity" "current" {}

resource "aws_eks_access_entry" "current" {
  cluster_name  = module.eks.cluster_name
  principal_arn = data.aws_caller_identity.current.arn
  type          = "STANDARD"

  depends_on = [module.eks]
}

resource "aws_eks_access_policy_association" "current_admin" {
  cluster_name  = module.eks.cluster_name
  principal_arn = data.aws_caller_identity.current.arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.current]
}

# Add explicit access entry for the specific user
resource "aws_eks_access_entry" "user_access" {
  cluster_name  = module.eks.cluster_name
  principal_arn = "arn:aws:iam::798974632222:user/artem.chernenko1496@gmail.com"
  type          = "STANDARD"

  depends_on = [module.eks]
}

resource "aws_eks_access_policy_association" "user_admin" {
  cluster_name  = module.eks.cluster_name
  principal_arn = "arn:aws:iam::798974632222:user/artem.chernenko1496@gmail.com"
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.user_access]
}
