prefix         = "arc"
env_short      = "u"
env            = "uat"
location       = "italynorth"
location_short = "itn"
domain         = "packer"

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "ARC"
  Source      = "https://github.com/pagopa/arc-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

azdo_agent_image_version    = "v20241209"
dns_forwarder_image_version = "v20241009"
