resource "azurerm_resource_group" "test" {
  name     = var.cluster_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "test" {
  name                = var.cluster_name
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  dns_prefix          = var.cluster_name

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "local_file" "kubeconfig" {
  content = azurerm_kubernetes_cluster.test.kube_config_raw
  filename = "${path.root}/kubeconfig"
}

