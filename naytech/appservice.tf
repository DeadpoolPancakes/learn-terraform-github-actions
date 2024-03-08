# Create an Azure App Service Plan
resource "azurerm_app_service_plan" "app_service_plan" {
    name                = "my-app-service-plan"
    location            = "UK South"
    resource_group_name = azurerm_resource_group.example.name
    kind                = "Linux"
    reserved            = true
    sku {
        tier = "PremiumV3"
        size = "P1v3"
    }
}

# Create an Azure App Service
resource "azurerm_app_service" "app_service" {
    name                = "my-app-service"
    location            = "UK South"
    resource_group_name = azurerm_resource_group.example.name
    app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

    site_config {
        always_on        = true
        ftps_state       = "Disabled"
        http2_enabled    = true
        use_32_bit_worker_process = true
        websockets_enabled = true
    }
    network_access_control {
        default_action = "Deny"
        ip_restriction {
            ip_address = azurerm_frontdoor.frontdoor.frontend_endpoints[0].custom_https_provisioning_ip_address
            action     = "Allow"
        }
    }
}

# Create an Azure App Service Slot
resource "azurerm_app_service_slot" "staging_slot" {
    name                = "staging"
    location            = "UK South"
    app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
    resource_group_name = azurerm_resource_group.example.name
    app_service_name    = azurerm_app_service.app_service.name
}
