terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.29"
    }
  }
  required_version = ">= 1.5.0"
}

variable "image" {
  type        = string
  description = "Container image for the hello-api app"
  default     = "hello-api:latest"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kind-pe-demo"
}
