# Configure the Azure provider
provider "azurerm" {
    features {}
}

# Create a resource group
resource "azurerm_resource_group" "example" {
    name     = "example-resource-group"
    location = "UK South"
}

# Create an Azure App Service
resource "azurerm_app_service" "example" {
    name                = "example-app-service"
    location            = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name
    app_service_plan_id = azurerm_app_service_plan.example.id

    site_config {
        always_on = true
    }
}

# Create an Azure App Service Plan
resource "azurerm_app_service_plan" "example" {
    name                = "example-app-service-plan"
    location            = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name
    kind                = "Linux"

    sku {
        tier = "Standard"
        size = "S1"
    }
}

# Create an Azure PostgreSQL database
resource "azurerm_postgresql_server" "example" {
    name                = "example-postgresql-server"
    location            = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name
    sku_name            = "B_Gen5_1"
    storage_mb          = 5120
    version             = "11"

    administrator_login          = "adminuser"
    administrator_login_password = "P@ssw0rd1234"

    auto_grow_enabled               = true
    backup_retention_days           = 7
    geo_redundant_backup_enabled    = false
    ssl_enforcement_enabled         = true
}

# Create an Azure Redis Cache
resource "azurerm_redis_cache" "example" {
    name                = "example-redis-cache"
    location            = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name
    sku_name            = "Basic"
    capacity            = 1
    enable_non_ssl_port = false
    minimum_tls_version = "1.2"
    family              = "C"
}
variable "environment" {
    description = "Environment tag"
    type        = string
    default     = "dev"
}
