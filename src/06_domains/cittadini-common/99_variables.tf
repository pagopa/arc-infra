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

variable "cdn_location" {
  type = string
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

# Domains
variable "external_domain" {
  type        = string
  description = "Domain for delegation"
}

variable "dns_zone_prefix" {
  type        = string
  description = "The dns subdomain."
}

variable "dns_zone_internal_prefix" {
  type        = string
  description = "The dns subdomain."
}

# AKS
variable "k8s_kube_config_path_prefix" {
  type    = string
  default = "~/.kube"
}

# CDN
variable "azuread_service_principal_azure_cdn_frontdoor_id" {
  type        = string
  description = "Azure CDN Front Door Principal ID - Microsoft.AzureFrontDoor-Cdn"
}

variable "private_cdn_enabled" {
  type        = bool
  description = "Flag to make FE (Blob Storage) private"
  default     = false
}

# VNET
variable "cidr_subnet_prv_endpoint" {
  type        = list(string)
  description = "CIDRs private endpoint subnet"
}

