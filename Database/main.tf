provider "azurerm" {
  features {}
   subscription_id = var.subscription_id
}

# SQL Server
resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sql_server_username
  administrator_login_password = var.sql_server_password

  identity {
    type = "SystemAssigned"
  }
}

# SQL Database
resource "azurerm_mssql_database" "sql_db" {
  name               = var.sql_server_dbname
  server_id          = azurerm_mssql_server.sql_server.id
  sku_name           = "Basic"
  collation          = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb        = 2
  zone_redundant     = false
  # auto_pause_delay_in_minutes = 60
  # min_capacity       = 0.5
}

# Allow Azure services to access the SQL Server
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}