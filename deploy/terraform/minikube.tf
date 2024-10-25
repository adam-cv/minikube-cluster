provider "minikube" {
  kubernetes_version = "v1.30.5"
}

resource "minikube_cluster" "docker" {
  driver       = "docker"
  cluster_name = "minikube"
  nodes        = 4
  memory       = "8192mb"
  addons = [
    "dashboard",
    "default-storageclass",
    "ingress",
    "storage-provisioner",
    "registry",
    "metrics-server",
  #  "ingress-dns"
  ]
}


provider "kubernetes" {
  host = minikube_cluster.docker.host
  client_certificate     = minikube_cluster.docker.client_certificate
  client_key             = minikube_cluster.docker.client_key
  cluster_ca_certificate = minikube_cluster.docker.cluster_ca_certificate
}
