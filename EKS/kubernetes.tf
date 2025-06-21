provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

resource "kubernetes_namespace" "example" {
  metadata {
    name = "my-namespace"
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx-deployment"
    namespace = kubernetes_namespace.example.metadata[0].name
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          name  = "nginx"
          image = "nginx:1.21.6"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}
