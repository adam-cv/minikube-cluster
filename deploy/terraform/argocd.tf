provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = "minikube"
}

resource "helm_release" "argocd-server" {
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "7.7.7"

  values = [file("values/argocd.yaml")]
}

data "kubectl_filename_list" "manifests" {
    pattern = "./manifests/*.yaml"
}

resource "kubectl_manifest" "argocd-manifests" {
    count = length(data.kubectl_filename_list.manifests.matches)
    yaml_body = file(element(data.kubectl_filename_list.manifests.matches, count.index))

    depends_on = [helm_release.argocd-server]
}