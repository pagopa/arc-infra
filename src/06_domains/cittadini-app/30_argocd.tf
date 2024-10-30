#
# Terraform argocd project
#
resource "argocd_project" "project" {
  metadata {
    name      = "${var.domain}-project"
    namespace = "argocd"
    labels = {
      acceptance = "true"
    }
  }

  spec {
    description = "${var.domain}-project"

    source_namespaces = ["argocd"]
    source_repos      = ["*"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = var.domain
    }
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "argocd"
    }

    #     cluster_resource_blacklist {
    #       group = "*"
    #       kind  = "*"
    #     }

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    namespace_resource_whitelist {
      group = "*"
      kind  = "*"
    }

    orphaned_resources {
      warn = true
    }

    #     role {
    #       name = "anotherrole"
    #       policies = [
    #         "p, proj:myproject:testrole, applications, get, myproject/*, allow",
    #         "p, proj:myproject:testrole, applications, sync, myproject/*, deny",
    #       ]
    #     }
  }
}

#
# Helm application
#
resource "argocd_application" "root_cittadini_app" {
  metadata {
    name      = "root-${var.domain}-app"
    namespace = "argocd"
    labels = {
      name : "root-${var.domain}-app"
      domain : var.domain
      is_root: true
    }
  }

  cascade = true
  wait    = true

  spec {
    project = argocd_project.project.metadata[0].name
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = var.domain
    }

    source {
      repo_url        = "https://github.com/pagopa/arc-cittadini-deploy-aks"
      target_revision = "main"
      path            = "helm/${var.env}"
      helm {
        values = yamlencode({
          _argocdProjectName : argocd_project.project.metadata[0].name
          _azureWorkloadIdentityClientId : module.workload_identity.workload_identity_client_id
          _gitRepoUrl : "https://github.com/pagopa/arc-cittadini-deploy-aks"
          _gitTargetRevision : "main"
          _helmPath : "helm/dev"
          _namespace : var.domain
        })
      }
    }

    #     sync_policy {
    #       automated {
    #         prune       = true
    #         self_heal   = false
    #         allow_empty = false
    #       }
    #
    #       retry {
    #         backoff {
    #           duration     = "5s"
    #           factor       = "2"
    #           max_duration = "3m0s"
    #         }
    #         limit = "5"
    #       }
    #     }
  }
}

#
# 🔒 secrets
#
resource "azurerm_key_vault_secret" "argocd_server_url" {
  name         = "argocd-server-url"
  key_vault_id = data.azurerm_key_vault.key_vault.id
  value        = var.argocd_server_addr
}
