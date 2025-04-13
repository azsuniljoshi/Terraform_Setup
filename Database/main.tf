provider "azurerm" {
  features {}
    subscription_id = "fab39a42-3122-457f-8903-c6e75c7ac237"
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-myazapp-eastasia-dev-001"
  location = "East Asia"
}

# SQL Server
resource "azurerm_mssql_server" "sql_server" {
  name                         = "sqlserver-azwebapp-00" 
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "sqluser"
  administrator_login_password = "myuser@1234" 

  identity {
    type = "SystemAssigned"
  }
}

# SQL Database
resource "azurerm_mssql_database" "sql_db" {
  name               = "sql-azwebapp-centraldindia-001"
  server_id          = azurerm_mssql_server.sql_server.id
  sku_name           = "Basic"
  collation          = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb        = 2
  zone_redundant     = false
  auto_pause_delay_in_minutes = 60
  min_capacity       = 0.5
}

# Allow Azure services to access the SQL Server
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
