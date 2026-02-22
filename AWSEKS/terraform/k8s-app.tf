resource "kubernetes_deployment" "test_app" {
  depends_on = [
    module.eks,
    aws_eks_access_policy_association.current_admin
  ]
  metadata {
    name = "test-app"
    labels = { app = "test-app" }
  }

  spec {
    replicas = 2

    selector {
      match_labels = { app = "test-app" }
    }

    template {
      metadata {
        labels = { app = "test-app" }
      }

      spec {
        container {
          name  = "httpd"
          image = "httpd:2.4"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "test_app" {
  metadata {
    name = "test-app"
  }

  spec {
    selector = { app = "test-app" }

    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}