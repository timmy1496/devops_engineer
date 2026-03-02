data "aws_eks_cluster" "this" {
  name       = module.eks.cluster_name
  depends_on = [
    module.eks,
    aws_eks_access_policy_association.current_admin
  ]
}

data "aws_eks_cluster_auth" "this" {
  name       = module.eks.cluster_name
  depends_on = [
    module.eks,
    aws_eks_access_policy_association.current_admin
  ]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
  load_config_file       = false
}
