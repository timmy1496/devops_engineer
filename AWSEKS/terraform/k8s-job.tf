resource "kubernetes_job" "hello" {
  depends_on = [
      module.eks,
      aws_eks_access_policy_association.current_admin,
      aws_eks_access_policy_association.user_admin
  ]
  metadata {
    name = "hello-job"
  }

  spec {
    template {
      metadata {}
      spec {
        restart_policy = "Never"

        container {
          name  = "hello"
          image = "busybox:1.36"
          command = ["sh", "-c", "echo 'Hello from EKS!'"]
        }
      }
    }

    backoff_limit = 1
  }
}