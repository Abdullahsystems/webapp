resource "azurerm_service_plan" "webapp-plan" {
  name                = "webapp-plan"
  resource_group_name = azurerm_resource_group.RS1.name
  location            = var.loc.location
  sku_name            = "S1"
  os_type             = "Windows"
  depends_on = [ azurerm_resource_group.RS1 ]
  
}

resource "azurerm_windows_web_app" "webapp" {
  name                = "webappperonaltest"
  resource_group_name = azurerm_resource_group.RS1.name
  location            = azurerm_resource_group.RS1.location
  service_plan_id     = azurerm_service_plan.webapp-plan.id
  depends_on = [ azurerm_resource_group.RS1,azurerm_service_plan.webapp-plan ]
  
  site_config {
  }
  https_only = true
}
  resource "azurerm_app_service_source_control" "github" {
  app_id = azurerm_windows_web_app.webapp.id
  repo_url = "https://github.com/Abdullahsystems/webapp"
  branch   = "main"  

}
resource "azurerm_windows_web_app_slot" "Testing" {
    name = "Testing3"
    
    app_service_id = azurerm_windows_web_app.webapp.id
    site_config {
        
    } 
    
}
resource "azurerm_windows_web_app_slot" "Testing2" {
    name = "Testing2"
    
    app_service_id = azurerm_windows_web_app.webapp.id
    site_config {
        
    } 
}
#   resource "azurerm_app_service_source_control" "github1" {
#   app_id = azurerm_windows_web_app_slot.Testing.id
#   repo_url = "https://github.com/Abdullahsystems/webapp"
#   branch   = "testinngwebapp"  

 

# }

