#
# 🔒 secrets
#
resource "azurerm_key_vault_secret" "argocd_server_url" {
  name         = "argocd-server-url"
  key_vault_id = data.azurerm_key_vault.key_vault.id
  value        = var.argocd_server_addr
}

#
# Terraform argocd project
#
resource "argocd_project" "cittadini_project" {
  metadata {
    name      = "${var.domain}-project"
    namespace = "argocd"
    labels = {
      acceptance = "true"
    }
  }

  spec {
    description = "${var.domain}-project"

    source_namespaces = ["cittadini"]
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


locals {
  argocd_applications = {
    "arc-be" = {
      name          = "arc-be"
      target_branch = "main"
    }
  }
}

resource "argocd_application" "arc_cittadini_applications" {
  for_each = local.argocd_applications

  metadata {
    name      = "${local.area}-${each.value.name}"
    namespace = "argocd"
    labels = {
      name   = "${local.area}-${each.value.name}"
      domain = var.domain
      area   = local.area
    }
  }

  spec {
    project = argocd_project.cittadini_project.metadata[0].name

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = var.domain
    }

    source {
      repo_url        = "https://github.com/pagopa/arc-cittadini-deploy-aks"
      target_revision = each.value.target_branch
      path            = "helm/${var.env}/${each.value.name}"

      helm {
        values = yamlencode({
          microservice-chart : {
            azure : {
              workloadIdentityClientId : module.workload_identity.workload_identity_client_id
            }
            serviceAccount : {
              name : module.workload_identity.workload_identity_service_account_name
            }
          }
        })
        ignore_missing_value_files = false
        pass_credentials           = false
        skip_crds                  = false
        value_files                = []
      }
    }

    # Sync policy configuration
    sync_policy {
      # sync_options = []
      #
      # automated {
      #   allow_empty = false
      #   prune       = false
      #   self_heal   = false
      # }
      #
      # retry {
      #   limit = "5"
      #
      #   backoff {
      #     duration     = "5s"
      #     factor       = "2"
      #     max_duration = "3m0s"
      #   }
      # }
    }

    ignore_difference {
      group         = "apps"
      kind          = "Deployment"
      json_pointers = ["/spec/replicas"]
    }
  }
}
