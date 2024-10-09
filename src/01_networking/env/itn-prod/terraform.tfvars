prefix         = "arc"
env_short      = "p"
env            = "prod"
location       = "italynorth"
location_short = "itn"
domain         = "core"

tags = {
  CreatedBy   = "Terraform"
  Environment = "PROD"
  Owner       = "ARC"
  Source      = "https://github.com/pagopa/arc-infra"
  CostCenter  = "TS310 - PAGAMENTI & SERVIZI"
}

#
# VNET
#

cidr_core_vnet         = ["10.1.0.0/16"]    # 10.1.0.0 --> 10.1.255.255
cidr_vpn_subnet        = ["10.1.128.0/24"]  # 10.1.128.0 --> 10.1.128.255
cidr_subnet_apim       = ["10.1.129.0/26"]  # 10.1.129.0 --> 10.1.129.63
cidr_subnet_azdoa      = ["10.1.129.64/26"] # 10.1.129.64 --> 10.1.129.127
cidr_subnet_appgateway = ["10.1.130.0/24"]  # 10.1.130.0 --> 10.1.130.255

# cidr_subnet_dns_forwarder_lb = ["10.1.200.0/29"] # 10.1.200.0 --> 10.1.200.7
# cidr_subnet_dns_vmss = ["10.1.200.8/29"] # 10.1.200.8 --> 10.1.200.15

# cidr_subnet_cittadini = ["10.1.163.0/24"] # 10.1.163.0 --> 10.1.163.255 Subnet is linked to the cittadini domain

#
# DNS
#

external_domain             = "pagopa.it"
dns_zone_prefix             = "cittadini"
dns_zone_internal_prefix    = "internal.cittadini"
dns_forwarder_image_version = "v20241009"
