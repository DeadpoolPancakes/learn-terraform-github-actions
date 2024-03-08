provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "example" {
    name     = "example-resource-group"
    location = "UK South"
}

resource "azurerm_redis_cache" "example" {
    name                = "example-redis-cache"
    location            = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name
    capacity            = 1
    family              = "C"
    sku_name            = "Basic"
    enable_non_ssl_port = false
}

output "redis_cache_connection_string" {
    value = azurerm_redis_cache.example.primary_connection_string
}
