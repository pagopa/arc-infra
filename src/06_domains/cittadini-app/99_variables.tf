variable "prefix" {
  type = string
  validation {
    condition = (
      length(var.prefix) <= 6
    )
    error_message = "Max length is 6 chars."
  }
}

variable "env" {
  type        = string
  description = "Environment"
}

variable "env_short" {
  type = string
  validation {
    condition = (
      length(var.env_short) <= 1
    )
    error_message = "Max length is 1 chars."
  }
}

variable "location" {
  type = string
}

variable "location_string" {
  type        = string
  description = "One of West Europe, North Europe"
}

variable "location_short" {
  type        = string
  description = "Location short like eg: neu, weu.."
}

variable "tags" {
  type = map(any)
  default = {
    CreatedBy = "Terraform"
  }
}

variable "domain" {
  type = string
  validation {
    condition = (
      length(var.domain) <= 12
    )
    error_message = "Max length is 12 chars."
  }
}

variable "k8s_kube_config_path_prefix" {
  type    = string
  default = "~/.kube"
}

variable "gpd_payments_pull_base_url" {
  type        = string
  description = "Url of pagopa payments pull api"
}

variable "bizevents_paids_base_url" {
  type        = string
  description = "Url of pagopa bizevents paids api"
}

variable "gpd_service_base_url" {
  type        = string
  description = "Url of pagopa gpd service api"
}

# Domains
variable "external_domain" {
  type        = string
  description = "Domain for delegation"
}

variable "dns_zone_prefix" {
  type        = string
  description = "The dns subdomain."
}

#
# ArgoCD
#
variable "argocd_server_addr" {
  type        = string
  description = "ArgoCD hostname"
}

variable "alert_enabled" {
  type = bool
}
