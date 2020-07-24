provider "azurerm" {
    version = "~>2.0"
    features {}
}

## Resource group                                

resource "azurerm_resource_group" "wvd-event-rg" {
  name     = "WVD-Event-RG"
  location = "UK South"

  tags = {
    environment = "wvd event"
     }
}

## Create NetApp Account and AD Connection  

resource "azurerm_netapp_account" "wvd-event-acc" {
  name                = "wvd-event-netapp-acc"
  resource_group_name = azurerm_resource_group.wvd-event-rg.name
  location            = azurerm_resource_group.wvd-event-rg.location

  active_directory {
    username            = "wvdadmin"
    password            = var.password
    smb_server_name     = "netapp"
    dns_servers         = ["172.16.1.4"]
    domain              = "myazuredemos.co.uk"
    organizational_unit = "OU=NetApp,OU=My Azure Demos"
  }
}

## Capacity Pool

resource "azurerm_netapp_pool" "wvd-event-netapp-pool" {
  name                = "wvd-event-netapp-pool"
  account_name        = azurerm_netapp_account.wvd-event-acc.name
  location            = azurerm_resource_group.wvd-event-rg.location
  resource_group_name = azurerm_resource_group.wvd-event-rg.name
  service_level       = "Premium"
  size_in_tb          = 4

  tags = {
    environment = "wvd event"
      }
}