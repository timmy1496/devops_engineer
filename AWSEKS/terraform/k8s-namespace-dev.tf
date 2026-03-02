resource "kubernetes_namespace" "dev" {
  depends_on = [
      module.eks,
      aws_eks_access_policy_association.current_admin,
      aws_eks_access_policy_association.user_admin
  ]
  metadata {
    name = "dev"
  }
}

resource "kubernetes_deployment" "busybox_dev" {
  metadata {
    name      = "busybox-sleeper"
    namespace = kubernetes_namespace.dev.metadata[0].name
    labels = { app = "busybox-sleeper" }
  }

  spec {
    replicas = 5

    selector {
      match_labels = { app = "busybox-sleeper" }
    }

    template {
      metadata {
        labels = { app = "busybox-sleeper" }
      }

      spec {
        container {
          name  = "busybox"
          image = "busybox:1.36"
          command = ["sh", "-c", "sleep 3600"]
        }
      }
    }
  }
}