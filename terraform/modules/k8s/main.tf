resource "kubernetes_config_map" "app_config" {
  metadata { name = "demo-app-config" }
  data = { GREETING = "Orchestration ECS + Kubernetes" }
}

resource "kubernetes_deployment" "app" {
  metadata {
    name   = "demo-app"
    labels = { app = "demo-app" }
  }
  spec {
    replicas = 2
    selector { match_labels = { app = "demo-app" } }
    template {
      metadata { labels = { app = "demo-app" } }
      spec {
        container {
          name  = "demo-app"
          image = "demo-app:1.0"
          port { container_port = 80 }
          resources {
            requests = { cpu = "100m", memory = "128Mi" }
            limits   = { cpu = "250m", memory = "256Mi" }
          }
          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 5
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata { name = "demo-app-svc" }
  spec {
    selector = { app = "demo-app" }
    port {
      port        = 80
      target_port = 80
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "app" {
  metadata { name = "demo-app-ingress" }
  spec {
    rule {
      host = "demo-app.local"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.app.metadata[0].name
              port { number = 80 }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v2" "app" {
  metadata { name = "demo-app-hpa" }
  spec {
    max_replicas = 5
    min_replicas = 2
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.app.metadata[0].name
    }
    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 50
        }
      }
    }
  }
}
