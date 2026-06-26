# Private DNS Zone for MySQL Flexible Server
resource "azurerm_private_dns_zone" "mysql_dns_zone" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

# Link the Private DNS Zone to the existing VNet
resource "azurerm_private_dns_zone_virtual_network_link" "mysql_dns_zone_link" {
  name                  = "${var.prefix}-mysql-dns-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.mysql_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

# ---------------------------------------------------------
# MySQL Flexible Server 1 (For Subnet 1)
# ---------------------------------------------------------
resource "azurerm_mysql_flexible_server" "mysql1" {
  name                   = "${var.prefix}-mysql-1"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  administrator_login    = var.mysql_admin_username
  administrator_password = var.mysql_admin_password
  sku_name               = "B_Standard_B1s"
  version                = "8.0.21"

  # Disabling public endpoints
  public_network_access_enabled = false
}

# Private Endpoint for MySQL 1 in Subnet 1
resource "azurerm_private_endpoint" "mysql1_pe" {
  name                = "${var.prefix}-mysql1-pe"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet1.id

  private_service_connection {
    name                           = "${var.prefix}-mysql1-privateserviceconnection"
    private_connection_resource_id = azurerm_mysql_flexible_server.mysql1.id
    subresource_names              = ["mysqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.mysql_dns_zone.id]
  }
}

# ---------------------------------------------------------
# MySQL Flexible Server 2 (For Subnet 2)
# ---------------------------------------------------------
resource "azurerm_mysql_flexible_server" "mysql2" {
  name                   = "${var.prefix}-mysql-2"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  administrator_login    = var.mysql_admin_username
  administrator_password = var.mysql_admin_password
  sku_name               = "B_Standard_B1s"
  version                = "8.0.21"

  # Disabling public endpoints
  public_network_access_enabled = false
}

# Private Endpoint for MySQL 2 in Subnet 2
resource "azurerm_private_endpoint" "mysql2_pe" {
  name                = "${var.prefix}-mysql2-pe"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet2.id

  private_service_connection {
    name                           = "${var.prefix}-mysql2-privateserviceconnection"
    private_connection_resource_id = azurerm_mysql_flexible_server.mysql2.id
    subresource_names              = ["mysqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.mysql_dns_zone.id]
  }
}
