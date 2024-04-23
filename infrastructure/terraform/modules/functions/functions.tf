resource "azurerm_service_plan" "service_plan" {
  name                = var.function_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name

  # maximum_elastic_worker_count = 20
  os_type                  = "Linux"
  per_site_scaling_enabled = false
  sku_name                 = var.function_sku
  worker_count             = 1     # Update to '3' for production
  zone_balancing_enabled   = false # Update to 'true' for production
}

resource "azurerm_linux_function_app" "assistant_function" {
  name                          = var.assistant_function_service_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  storage_account_name          = var.storage_account_name
  service_plan_id               = azurerm_service_plan.service_plan.id
  storage_uses_managed_identity = true
  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_assigned_identity_id]
  }
  app_settings = {
    ENABLE_ORYX_BUILD              = true
    SCM_DO_BUILD_DURING_DEPLOYMENT = true
    FUNCTIONS_WORKER_RUNTIME       = "python"
  }
  site_config {
    application_stack {
      python_version = "3.11"
    }
  }
  zip_deploy_file = data.archive_file.function.output_path
}

resource "azurerm_linux_function_app" "shortclip_function" {
  name                          = var.shortclip_function_service_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  storage_account_name          = var.storage_account_name
  service_plan_id               = azurerm_service_plan.service_plan.id
  storage_uses_managed_identity = true
  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_assigned_identity_id]
  }
  app_settings = {
    ENABLE_ORYX_BUILD              = true
    SCM_DO_BUILD_DURING_DEPLOYMENT = true
    FUNCTIONS_WORKER_RUNTIME       = "python"
  }
  site_config {
    application_stack {
      python_version = "3.11"
    }
  }
  zip_deploy_file = data.archive_file.rag_video_tagging.output_path
}
