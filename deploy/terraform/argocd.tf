resource "helm_release" "argocd-server" {
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "7.6.12"

  values = [file("values/argocd.yaml")]

  depends_on = [minikube_cluster.docker]
}

data "kubectl_filename_list" "manifests" {
    pattern = "./manifests/*.yaml"
}

resource "kubectl_manifest" "argocd-manifests" {
    count = length(data.kubectl_filename_list.manifests.matches)
    yaml_body = file(element(data.kubectl_filename_list.manifests.matches, count.index))

    depends_on = [helm_release.argocd-server]
}