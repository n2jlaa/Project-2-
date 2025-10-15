resource "azurerm_resource_group" "rg" {
 resource_group_name = data.azurerm_resource_group.rg.name
location            = data.azurerm_resource_group.rg.location

}

