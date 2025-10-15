terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.117"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-najla-devopsproj2"
    storage_account_name = "najlaatfstateacct"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    # لو تبي تستخدمين Azure AD بدلاً من access key:
    # use_azuread_auth = true
  }
}

provider "azurerm" {
  features {}
  # تقدر تتركي الاشتراك بدون ما تكتبيه هنا وتستخدمي az login + az account set
  # أو عبر متغير بيئة ARM_SUBSCRIPTION_ID
  subscription_id = "4421688c-0a8d-4588-8dd0-338c5271d0af"
}
