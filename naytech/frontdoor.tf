# Provider configuration
provider "azurerm" {
    features {}
}

# Resource group
resource "azurerm_resource_group" "example" {
    name     = "example-resource-group"
    location = "West Europe"
}

# Front Door
resource "azurerm_frontdoor" "example" {
    name                = "example-frontdoor"
    resource_group_name = azurerm_resource_group.example.name
    location            = azurerm_resource_group.example.location
    tags                = { "Environment" = "Production" }
}

# Front Door Backend Pool
resource "azurerm_frontdoor_backend_pool" "example" {
    frontdoor_id = azurerm_frontdoor.example.id
    name         = "example-backend-pool"
    load_balancing_settings {
        sample_size       = 4
        successful_samples_required = 2
    }
}

# Front Door Frontend Endpoint
resource "azurerm_frontdoor_frontend_endpoint" "example" {
    frontdoor_id = azurerm_frontdoor.example.id
    name         = "example-frontend-endpoint"
    host_name    = "example.com"
    session_affinity_enabled = true
    session_affinity_ttl_seconds = 3600
    custom_https_provisioning_enabled = true
    custom_https_configuration {
        certificate_source = "FrontDoor"
        protocol_type      = "ServerNameIndication"
    }
}

# Front Door Routing Rule
resource "azurerm_frontdoor_routing_rule" "example" {
    frontdoor_id = azurerm_frontdoor.example.id
    name         = "example-routing-rule"
    accepted_protocols = ["Https"]
    patterns_to_match = ["/"]
    enabled_state = "Enabled"
    forwarding_configuration {
        frontend_endpoint_id = azurerm_frontdoor_frontend_endpoint.example.id
        backend_pool_id      = azurerm_frontdoor_backend_pool.example.id
        forwarding_protocol  = "MatchRequest"
    }
}

# Web Application Firewall (WAF)
resource "azurerm_frontdoor_web_application_firewall_policy" "example" {
    name                = "example-waf-policy"
    resource_group_name = azurerm_resource_group.example.name
    location            = azurerm_resource_group.example.location
    tags                = { "Environment" = "Production" }
}

# Front Door WAF Policy Association
resource "azurerm_frontdoor_web_application_firewall_policy_association" "example" {
    frontdoor_id                     = azurerm_frontdoor.example.id
    web_application_firewall_policy_id = azurerm_frontdoor_web_application_firewall_policy.example.id
}
