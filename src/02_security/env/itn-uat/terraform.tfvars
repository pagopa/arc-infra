# general
prefix         = "arc"
env_short      = "u"
env            = "uat"
domain         = "core"
location       = "italynorth"
location_short = "itn"
p4pa_owner     = true

tags = {
  CreatedBy   = "Terraform"
  Environment = "UAT"
  Owner       = "ARC"
  Source      = "https://github.com/pagopa/arc-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

input_file = "./secret/itn-uat/configs.json"