# general
prefix         = "arc"
env_short      = "p"
env            = "prod"
domain         = "core"
location       = "italynorth"
location_short = "itn"
p4pa_owner     = true

tags = {
  CreatedBy   = "Terraform"
  Environment = "PROD"
  Owner       = "ARC"
  Source      = "https://github.com/pagopa/arc-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

input_file = "./secret/itn-prod/configs.json"