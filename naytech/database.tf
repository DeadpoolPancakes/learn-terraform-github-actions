resource "azurerm_resource_group" "example" {
    name     = "example-resource-group"
    location = "uksouth"
}

resource "azurerm_postgresql_server" "example" {
    name                = "example-postgresql-server"
    location            = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name
    sku_name            = "B_Gen5_1"
    storage_mb          = 5120
    version             = "11"

    administrator_login          = "admin"
    administrator_login_password = "P@ssw0rd123!"

    ssl_enforcement_enabled = true
    ssl_minimal_tls_version_enforced = "TLS1_2"

    auto_grow_enabled = true
    backup_retention_days = 7
    geo_redundant_backup_enabled = false

    public_network_access_enabled = false

    tags = {
        environment = "dev"
    }
}

resource "azurerm_postgresql_firewall_rule" "example" {
    name                = "example-firewall-rule"
    resource_group_name = azurerm_resource_group.example.name
    server_name         = azurerm_postgresql_server.example.name
    start_ip_address    = "10.0.0.0"
    end_ip_address      = "10.0.0.255"
}
