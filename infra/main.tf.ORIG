resource "kubernetes_namespace" "demo" {
  metadata {
    name = "platform-demo"
  }
}

resource "kubernetes_deployment" "hello" {
  # Avoid long waits in demos if pods aren't ready yet
  wait_for_rollout = false

  metadata {
    name      = "hello-api"
    namespace = kubernetes_namespace.demo.metadata[0].name
    labels = {
      app = "hello-api"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "hello-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "hello-api"
        }
      }

      spec {
        container {
          name  = "hello-api"
          image = var.image

          # IMPORTANT: do NOT try to pull from a registry.
          image_pull_policy = "Never"

          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "hello" {
  metadata {
    name      = "hello-api"
    namespace = kubernetes_namespace.demo.metadata[0].name
  }

  spec {
    selector = {
      app = "hello-api"
    }

    port {
      port        = 5000   # service port
      target_port = 5000   # container port
    }

    type = "ClusterIP"
  }
}
