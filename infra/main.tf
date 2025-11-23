# Namespace for the demo
resource "kubernetes_namespace" "demo" {
  metadata {
    name = "platform-demo"
  }
}

# Hardened Deployment with probes, resources, and securityContext
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
        # checkov:skip=CKV_K8S_14: Using 'latest' tag in a local demo cluster, not production
        # checkov:skip=CKV_K8S_43: Not using image digest in this local demo; would use in prod
        # checkov:skip=CKV_K8S_15: ImagePullPolicy 'IfNotPresent' is required for kind-loaded local images

        container {
          name  = "hello-api"
          image = var.image

          # For local kind: we load the image into the node; 'IfNotPresent' avoids broken pulls
          image_pull_policy = "IfNotPresent"

          port {
            container_port = 5000
          }

          # --- Health probes (fix CKV_K8S_8 and CKV_K8S_9) ---
          liveness_probe {
            http_get {
              path = "/health"
              port = 5000
            }
            initial_delay_seconds = 5
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 5000
            }
            initial_delay_seconds = 2
            period_seconds        = 5
          }

          # --- Resources (fix CKV_K8S_10, 11, 12, 13) ---
          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          # --- Security context (fix CKV_K8S_28, 29, 30, etc.) ---
          security_context {
            run_as_non_root            = true
            run_as_user                = 1000
            read_only_root_filesystem  = true
            allow_privilege_escalation = false

            capabilities {
              drop = ["ALL"]
            }
          }
        }
      }
    }
  }
}

# Service to expose the app inside the cluster
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

