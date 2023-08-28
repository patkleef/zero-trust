---
layout: single
title:  "Secure Azure PaaS services with Azure Private Link"
description: "By using Private Link, we can securely connect to PaaS services from a VNET without exposing the service to the public internet."
date:   2023-08-28 14:30:00 +0100
categories: infrastructure
tags: infrastructure
author_profile: true
share: true
classes: wide
show_date: true
published: true

---
When using Azure you shouldn't take the security of your data and services for granted. Microsoft explicitly states that security is a shared responsibility between Azure and it's cloud users. Take PaaS services for instance, if you use a storage account but don't secure it properly you are increasing the risk of a data breach. In this article, I'll guide you through securing your PaaS services using Azure Private Link.

<div class="notice--info">
    <strong>PaaS (Platform as a Service) services</strong> in Azure refer to a category of cloud computing services that provide a platform for developing, deploying, and managing applications without the need to manage the underlying infrastructure. Azure PaaS services abstract away the complexities of infrastructure management, allowing developers to focus on building and deploying their applications. Example of PaaS services are app services, SQL Databases and storage accounts.
</div>

The <a href="/smartmoney">SmartMoney</a> workload is divided into a frontend and backend API application. The backend API application is responsible for storing and retrieving data from the SQL Database and storage account. The frontend application only interacts with the backend API application, eliminating the need for accessing the SQL Database and storage account directly. Below the creation of the frontend app service with Terraform.

```terraform
resource "azurerm_service_plan" "asp_frontend" {
  name                = "asp-frontend-app"
  resource_group_name = azurerm_resource_group.rg_smartmoney.name
  location            = local.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app_frontend" {
  name                = "app-smartmoney-frontend-app"
  resource_group_name = azurerm_resource_group.rg_smartmoney.name
  location            = local.location
  service_plan_id     = azurerm_service_plan.asp_frontend.id

  site_config {
    always_on = false
    application_stack {
        dotnet_version = "7.0"
    }
  }
}
```


By default, PaaS services are accessible to the public. Let's confirm this by using a simple 'dig' command on the app service (`app-smartmoney-frontend-app.azurewebsites.net`) we created earlier.

```bash
dig app-smartmoney-frontend-app.azurewebsites.net

; <<>> DiG 9.16.1-Ubuntu <<>> app-smartmoney-frontend-app.azurewebsites.net
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 6985
;; flags: qr rd ad; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 0
;; WARNING: recursion requested but not available

;; QUESTION SECTION:
;app-smartmoney-frontend-app.azurewebsites.net. IN A

;; ANSWER SECTION:
app-smartmoney-frontend-app.azurewebsites.net. 0 IN CNAME waws-prod-am2-595.sip.azurewebsites.windows.net.
waws-prod-am2-595.sip.azurewebsites.windows.net. 0 IN CNAME waws-prod-am2-595-fc34.westeurope.cloudapp.azure.com.
waws-prod-am2-595-fc34.westeurope.cloudapp.azure.com. 0 IN A 20.105.232.15
```

As you can see a public IP `20.105.232.15` is returned. While we aim to enable OneFinance employees to work remotely, we do not intend to make SmartMoney accessible to the public. Let's continue with the risks of exposing your PaaS services to the internet. 

## What are the risks of exposing your PaaS services to the internet?

When exposing your PaaS services to the internet you are increasing the attack surface of your application. This means that you are increasing the number of ways an attacker can try to compromise your application or steal data. It depends, how a storage account and Azure SQL Database is secured but when exposing these services to the internet you are increasing the risk of a data breach.

<div class="notice--primary">
    <h3>Millions of Dow Jones Customer Records Exposed Online 2017</h3>
    <p>Dow Jones & Company unintentionally exposed customer details, including names, addresses, subscription information, and partial credit card numbers. The data was found in an improperly configured Amazon Web Services (AWS) S3 bucket. The breach occurred because Dow Jones employees had granted access to anyone with an AWS account, of which there are over one million users. </p>

    <i><a href="https://www.securityweek.com/millions-dow-jones-customer-records-exposed-online/" target="_blank">source: securityweek.com</a></i>
</div>

Not only was the S3 bucket publicly accessible, but the permissions were also misconfigured. This data was clearly not meant to be publicly accessible. Let's take a look which options we have to secure PaaS services in Azure.

## Private Link vs Service Endpoints
Service endpoints and Private Link are two different ways to secure your PaaS services. Service endpoints allow your virtual network resources to communicate with an Azure service’s public endpoint using private IP addresses. Traffic to the Azure service always remains on the Microsoft Azure backbone network, so it doesn't flow over the internet. By integrating with Azure Virtual Network, Service Endpoints allow for more granular control in terms of which subnets can access the service. For instance, you could restrict an Azure Storage account to only be accessible from a particular subnet within your VNet. An example, how service endpoint for a storage account is enabled on a subnet and how the storage account only restricts traffic from that subnet.

```terraform
resource "azurerm_subnet" "subnet_private" {
  name                 = "snet-private"
  resource_group_name  = azurerm_resource_group.rg_smartmoney.name
  virtual_network_name = azurerm_virtual_network.vnet_smartmoney.name
  address_prefixes     = ["10.1.48.0/20"]

  service_endpoints = [
    "Microsoft.Storage"
  ]
}

resource "azurerm_storage_account" "example_storage_account" {
  name                     = "stexample123"
  resource_group_name      = "rg"
  location                 = "westeurope"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [azurerm_subnet.subnet_private.id]
  }
}
```



 In comparison, Private Link allows you to make the PaaS service part of your virtual network. The PaaS service gets a network interface in your virtual network and is assigned a private IP address. Traffic to the PaaS service never leaves your virtual network and therefor public access to the PaaS service can be disabled. Microsoft recommends using Private Link over service endpoints.

## Use Private Link to secure the SmartMoney PaaS services

The <a href="/smartmoney">SmartMoney</a> application, manage the financial records of customers. The senstive data is stored in Azure SQL Database and storage account. A data breach to one of those PaaS services would be catastrophic for OneFinance. For that reason, we want to disable public access and secure the PaaS services with Private Link. Below the architecture of the SmartMoney application.

<img src="/assets/diagrams/smartmoney-hub-spoke-network-topology.drawio.png"  />

### How does Private Link works

When enabling Private Link for a PaaS service, a private endpoint is created which is essentially a private IP address (network interface) from your VNET. This private IP address can be used to access the PaaS service in your VNET. Using a private IP address is not very user-friendly, so a private DNS zone can be created to map the private IP address to the FQDN of the PaaS service. Even though, you could enable everything from the Azure portal I recommend to use IaC. I'll explain in a future article why from a maintainability and security perspective this is a better option. Below the creation of a private endpoint for the frontend app service.

```terraform
resource "azurerm_private_endpoint" "frontend" {
  count               = local.enable_frontend_app_private_endpoint ? 1 : 0

  name                = "pv-smartmoney-frontend-app"
  resource_group_name = azurerm_resource_group.rg_smartmoney.name
  location            = local.location
  subnet_id           = azurerm_subnet.subnet_private_endpoint.id

  private_dns_zone_group {
    name                 = "app-smartmoney-frontend-app-private-endpoint-zg"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_app_service.id]
  }

  private_service_connection {
    name                           = "pv-smartmoney-frontend-app"
    private_connection_resource_id = azurerm_linux_web_app.app_frontend.id
    is_manual_connection           = false  
    subresource_names              = ["sites"]
  }
}
```

The private endpoint resource is linked to the PaaS service via the `private_service_connection` property. The `private_dns_zone_group` property is used to link the private endpoint to the private DNS zone. The private DNS zone is used to resolve the FQDN of the PaaS service to the private IP address of the private endpoint. An A record is automatically created in the private DNS zone when enabling Private Link.

After enabling Private Link for the app service, the private IP address of the app service is returned when doing a DNS lookup <u>inside the network</u>. This is an important detail, because when doing a DNS lookup from outside the network, the public address is still returned. Will come back to that later. First let's take a look at the DNS lookup result.

```bash 
; <<>> DiG 9.16.22 <<>> app-smartmoney-frontend-app.azurewebsites.net
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 58686
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1224
;; QUESTION SECTION:
;app-smartmoney-frontend-app.azurewebsites.net. IN A

;; ANSWER SECTION:
app-smartmoney-frontend-app.azurewebsites.net. 1800 IN CNAME app-smartmoney-frontend-app.privatelink.azurewebsites.net.
app-smartmoney-frontend-app.privatelink.azurewebsites.net. 10 IN A 10.1.32.4

;; Query time: 19 msec
;; SERVER: 168.63.129.16#53(168.63.129.16)
;; WHEN: Mon Aug 14 12:19:26 UTC 2023
;; MSG SIZE  rcvd: 144
```

As you can see a private IP address is returned. This is the private IP address of the network interface that is connected to the private endpoint resource. We can see that in the portal as well.

<img src="/assets/images/blog-privatelink-nic.jpg"  />

A record is automatically created for the Private Endpoint in the private DNS zone. This record returns the private IP address of the Private Endpoint. I created the private DNS zone and linked it to the hub and spoke network:

```terraform
resource "azurerm_private_dns_zone" "private_dns_app_service" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg_hub.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_app_service_hub_link" {
  name                  = "private-dns-appservice-link-hub"
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_app_service.name
  virtual_network_id    = azurerm_virtual_network.vnet_hub.id
  resource_group_name   = azurerm_resource_group.rg_hub.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_app_service_spoke_link" {
  name                  = "private-dns-appservice-link-spoke"
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_app_service.name
  virtual_network_id    = azurerm_virtual_network.vnet_smartmoney.id
  resource_group_name   = azurerm_resource_group.rg_hub.name
}
```

When the Private Endpoint is deployed, an A record automatically appear in the Private DNS zone.

<img src="/assets/images/blog-privatelink-privatednszone.jpg"  />

Let me summarize what happens when calling a PaaS service with Private Link enabled from a resource in the VNET:
- Resource in the VNET executes a DNS lookup for `app-smartmoney-frontend-app.azurewebsites.net`.
- The request is handled by the DNS server from Azure running on the reserved IP `168.63.129.16`. This is a static IP used by Azure to resolve DNS requests inside the network.
- The DNS server detects that Private Link is enabled for the PaaS service and returns a CNAME record `app-smartmoney-frontend-app.privatelink.azurewebsites.net`.
- The private DNS zone `privatelink.azurewebsites.net` is linked to the VNET and this zone holds an A record that resolves to the private endpoint IP address.
- The resource in the VNET uses this IP address to access the PaaS service.
- The private Endpoint communicates with the PaaS service securely over the Azure backbone network.

### Block public access to the app service

When enabling Private Link for an app service, the app service remains publicly accessible. When we perform an DNS lookup outside network the public IP address of the PaaS service is returned. To eliminate public access to the app service we need to set the `public_network_access_enabled` property to `false`.

```terraform

resource "azurerm_linux_web_app" "app_frontend" {
  name                = "app-smartmoney-frontend-app"
  resource_group_name = azurerm_resource_group.rg_smartmoney.name
  location            = local.location
  service_plan_id     = azurerm_service_plan.asp_frontend.id
  public_network_access_enabled = false

  ...
}
```

When accessing the app service from outside the network, the following error is returned:
<img src="/assets/images/blog-privatelink-forbidden.jpg" />

## Implement Private Link for SQL Database and Storage Account

Enabling Private Link for SQL Database and storage account is similar to the app service. The only difference is that we need to create a private DNS zone for the SQL Database and Storage Account. Below the code for enabling Private Link for the storage account.

```terraform
resource "azurerm_storage_account" "smartmoney_storage_account" {
  name                     = "stsmartmoney"
  resource_group_name      = azurerm_resource_group.rg_smartmoney.name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  
  public_network_access_enabled = false
}

resource "azurerm_private_endpoint" "smartmoney_storage_account_private_endpoint" {
  name                = "pep-smartmoney-storage-account"
  resource_group_name = azurerm_resource_group.rg_smartmoney.name
  location            = local.location
  subnet_id           = azurerm_subnet.subnet_private_endpoint.id

  private_dns_zone_group {
    name                 = "smartmoney-storage-account-private-endpoint-zg"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns_storage_account.id]
  }

  private_service_connection {
    name                           = "pep-smartmoney-storage-account"
    private_connection_resource_id = azurerm_storage_account.smartmoney_storage_account.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}

resource "azurerm_private_dns_zone" "private_dns_storage_account" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg_hub.name
}
```

The Terraform code is available in the <a href="https://github.com/patkleef/zero-trust/tree/main/infra" target="_blank">github.com/patkleef/zero-trust</a> repository. With each article, I will make updates to the source code.


## Zero Trust principles

By using Private Link to connect to the PaaS service and disable public access, you reduce the attack surface and minimize the exposure of the service to potential threats from the public internet.

**Verify explicitly**

With Private Link, Azure ensures that traffic to the PaaS service travels only over the Azure backbone network. This network traffic doesn't traverse the public internet and only resources inside the network can access the PaaS service. By doing this, access to resources is explicitly verified and not exposed by default to the wider internet.

**Assume breach**

If a malicious actor gains access to the credentials of the storage account or SQL Database, the actor can't access the resources because the PaaS service is only accessible from the VNET. The actor needs to gain access to the VNET to access the PaaS service with the compromised credentials. I'll discuss how to further secure the storage account and SQL Database in a future article.

## What's next

Now that we deployed and limit access to the PaaS services from the VNET, it's time to give employees access to the application. In the next article, I'll explain how users can access the application by using the App Proxy service.