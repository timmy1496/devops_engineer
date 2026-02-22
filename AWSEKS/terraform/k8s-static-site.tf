resource "kubernetes_config_map" "site" {
  depends_on = [module.eks, aws_eks_addon.ebs_csi]
  metadata {
    name = "static-site"
  }

  data = {
    "index.html" = <<-EOT
      <!doctype html>
      <html>
        <head><title>EKS Static Site</title></head>
        <body style="font-family: Arial">
          <h1>Hello from EKS!</h1>
          <p>Served by nginx + ConfigMap</p>
        </body>
      </html>
    EOT
  }
}

resource "kubernetes_deployment" "nginx_site" {
  metadata {
    name = "nginx-site"
    labels = { app = "nginx-site" }
  }

  spec {
    replicas = 2

    selector {
      match_labels = { app = "nginx-site" }
    }

    template {
      metadata {
        labels = { app = "nginx-site" }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:stable"

          port {
            container_port = 80
          }

          volume_mount {
            name       = "site"
            mount_path = "/usr/share/nginx/html"
            read_only  = true
          }
        }

        volume {
          name = "site"
          config_map {
            name = kubernetes_config_map.site.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx_lb" {
  metadata {
    name = "nginx-site-lb"
  }

  spec {
    selector = { app = "nginx-site" }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}