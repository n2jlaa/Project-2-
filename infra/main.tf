resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-najla-devopsproj2"
    storage_account_name = "najlaatfstateacct"
    container_name       = "tfstate"
    key                  = "devops2-najla/terraform.tfstate"
    use_azuread_auth     = true
  }
}
