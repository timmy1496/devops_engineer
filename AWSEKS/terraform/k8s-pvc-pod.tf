resource "kubernetes_storage_class" "gp3" {
  depends_on = [
      module.eks,
      aws_eks_access_policy_association.current_admin,
      aws_eks_access_policy_association.user_admin
  ]
  metadata {
    name = "gp3"
  }

  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Delete"
  volume_binding_mode = "WaitForFirstConsumer"

  parameters = {
    type = "gp3"
  }
}

resource "kubernetes_persistent_volume_claim" "data" {
  metadata {
    name = "data-pvc"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "1Gi"
      }
    }

    storage_class_name = kubernetes_storage_class.gp3.metadata[0].name
  }
}

resource "kubernetes_pod" "pvc_writer" {
  metadata {
    name = "pvc-writer"
  }

  spec {
    container {
      name  = "writer"
      image = "busybox:1.36"
      command = ["sh", "-c", "date >> /data/out.txt; sleep 3600"]

      volume_mount {
        name       = "data"
        mount_path = "/data"
      }
    }

    volume {
      name = "data"
      persistent_volume_claim {
        claim_name = kubernetes_persistent_volume_claim.data.metadata[0].name
      }
    }
  }
}