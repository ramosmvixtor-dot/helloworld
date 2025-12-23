resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true
  timeout          = 600 # 10 minutes wait for installation

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }
  
  depends_on = [google_container_node_pool.nodes]
}
