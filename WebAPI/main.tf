provider "azurerm" {
  features {}
   subscription_id = "fab39a42-3122-457f-8903-c6e75c7ac237"
}

# resource "azurerm_resource_group" "rg" {
#   name     = var.resource_group_name
#   location = var.location
# }

resource "azurerm_service_plan" "asp" {
  name                = "${var.app_name}-asp"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
   sku_name           = "B1"
}

resource "azurerm_linux_web_app" "webapp" {
  name                = var.app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      dotnet_version = "9.0"
    }
  }

  app_settings = {
    "WEBSITES_PORT" = "5000"
  }
}
