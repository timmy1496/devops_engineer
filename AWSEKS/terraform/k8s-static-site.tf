resource "kubernetes_config_map" "site" {
  depends_on = [
      null_resource.k8s_ready
  ]
  metadata {
    name = "static-site"
  }

  data = {
    "index.html" = <<-EOT
      <!doctype html>
      <html>
        <head><title>EKS Static Site</title></head>
        <body style="font-family: Arial">
          <h1>🎉 Вітаємо в AWS EKS!</h1>
          <h2>Статичний сайт успішно розгорнуто</h2>
          <div style="background: #f0f0f0; padding: 20px; margin: 20px 0; border-radius: 5px;">
            <h3>📋 Інформація про середовище:</h3>
            <p><strong>🏷️ Кластер:</strong> ${var.project}-cluster</p>
            <p><strong>🌍 Регіон:</strong> ${var.region}</p>
            <p><strong>⏰ Час розгортання:</strong> ${timestamp()}</p>
          </div>
          <div style="background: #e8f5e8; padding: 20px; margin: 20px 0; border-radius: 5px;">
            <h3>✅ Статус компонентів:</h3>
            <ul>
              <li>✅ EKS Cluster - Активний</li>
              <li>✅ LoadBalancer - Працює</li>
              <li>✅ Nginx Pod - Запущений</li>
              <li>✅ ConfigMap - Завантажений</li>
            </ul>
          </div>
          <div style="background: #fff3cd; padding: 20px; margin: 20px 0; border-radius: 5px;">
            <h3>🔗 Корисні посилання:</h3>
            <ul>
              <li><a href="https://kubernetes.io/docs/">Документація Kubernetes</a></li>
              <li><a href="https://aws.amazon.com/eks/">AWS EKS</a></li>
              <li><a href="https://terraform.io/docs/">Terraform Documentation</a></li>
            </ul>
          </div>
          <footer style="margin-top: 40px; text-align: center; color: #666;">
            <p>Розгорнуто за допомогою Terraform та AWS EKS</p>
          </footer>
        </body>
      </html>
    EOT
  }
}

resource "kubernetes_deployment" "nginx_site" {
  depends_on = [
    null_resource.k8s_ready,
    kubernetes_config_map.site
  ]

  timeouts {
    create = "15m"
    update = "15m"
    delete = "10m"
  }

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
          image = "nginx:1.25-alpine"

          port {
            container_port = 80
          }

          volume_mount {
            name       = "site-content"
            mount_path = "/usr/share/nginx/html"
          }

          # Додання health checks
          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }

          # Ресурси для стабільної роботи
          resources {
            limits = {
              cpu    = "100m"
              memory = "128Mi"
            }
            requests = {
              cpu    = "50m"
              memory = "64Mi"
            }
          }
        }

        volume {
          name = "site-content"
          config_map {
            name = kubernetes_config_map.site.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx_lb" {
  depends_on = [
    null_resource.k8s_ready,
    kubernetes_deployment.nginx_site
  ]

  timeouts {
    create = "10m"
    delete = "5m"
  }

  metadata {
    name = "nginx-site-lb"
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type" = "nlb"
      "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"
    }
  }

  spec {
    selector = { app = "nginx-site" }

    port {
      name        = "http"
      port        = 80
      target_port = 80
      protocol    = "TCP"
    }

    type = "LoadBalancer"
  }
}
