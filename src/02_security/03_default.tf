resource "azurerm_resource_group" "default_roleassignment_rg" {
  count = var.p4pa_owner ? 0 : 1

  #Important: do not create any resource inside this resource group
  name     = "default-roleassignment-rg"
  location = var.location

  tags = var.tags
}
