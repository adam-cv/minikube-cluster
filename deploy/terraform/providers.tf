terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.33.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.16.1"
    }
    minikube = {
      source = "scott-the-programmer/minikube"
      version = "0.4.2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# provider "kubectl" {
#   kubernetes {
#     config_path = "~/.kube/config"
#   }
# }