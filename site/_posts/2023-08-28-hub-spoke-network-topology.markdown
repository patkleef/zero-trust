---
layout: single
title:  "Centralize management with the hub-spoke network topology"
description: "The hub-spoke network topology is the foundation of a secure cloud infrastructure. It offers centralized management, cost-effective, scalability and security."
date:   2023-08-28 14:30:00 +0100
categories: infrastructure
tags: infrastructure
author_profile: true
share: true
classes: wide
show_date: true
published: true
read_time: true
---

<div class="notice--info">
    OneFinance has many different applications that were brought to the cloud in unplanned way. During Corona OneFinance (like many other companies) ensured that employees could work from home. This was done by quickly moving applications to the cloud without a clear strategy. Now that the dust has settled, OneFinance wants to make sure that the applications are secure and that the infrastructure is managed in a structured way. The first step is choosing the right network topology. This article will help you understand what the hub-spoke network topology is and how it can be used to secure the infrastructure. If you haven't, read more about the SmartMoney application <a href="/smartmoney">here</a>.
</div>

## What is the hub spoke network topology?
When migrating workloads to the cloud, it's important to choose the correct network architecture. A well-chosen network topology serves as the foundation of a robust cloud infrastructure. The hub-spoke network topology is considered a best practice. Wherein each workload is deployed in a spoke network that is connected to a central hub network. This architecture offers several benefits, including centralized management of shared services through the hub, streamlined traffic flow, reduce costs, and improved security.

<img src="/assets/diagrams/hub-spoke-network-topology.drawio.png"  />

The diagram illustrates the interconnectedness of the spokes with the hub. The hub controls the flow of inbound and outbound traffic between the spokes and the internet/onpremise network. To establish a secure connection between the spokes and an on-premises network, it is recommended to deploy a VPN gateway in the hub. This can be used for point-to-site or site-to-site VPN connections. By deploying services to the hub, organizations can achieve centralized management and reduce costs.

## When should you use the hub-spoke network topology?
A hub-spoke topology offers certain advantages and disadvantages. It's important to understand these before deciding to use this topology. In general, you would like to use the hub-spoke topology in an organization that has many workloads (usually maintained by different devops team) that should be deployed to the cloud. The hub-spoke topology is not the silver bullet for all use-cases so it's important to understand the benefits and drawbacks.

### What are the benefit?
- Centralized management
    - Easier to configure and manage network policies, routing, and security.
- Cost-effective
    - Shared resources in the hub reduce the need of redundant resources in each spoke.
- Scalability
    - Easy to add new spokes without effecting the central hub.
- Security
    - Secure all inbound and outbound traffic through the hub.
- Separation of concerns
    - Spokes can be managed by different teams.

### Drawbacks
- Single point of failure
    - If the hub goes down, all the spokes are disconnected.
- Network latency
    - All traffic goes through the hub, more hops and longer distance.
- Complex routing
    - All spokes need to be configured to route traffic through the hub.
- Limited flexibility
    - All spokes are connected to the same hub, no direct connection between spokes.

In the next section, I'll explain why OneFinance should use the hub-spoke topology and describe the implementation for the SmartMoney application. First a few examples where the hub-spoke topology might not be the best choice:
- If you have a single workload that needs to be deployed to the cloud and in the future, you don't expect more workloads.
- When you don't want central management for security (or connectivity). If each workload requires a different security policy, it's better to use a different topology.

<div class="notice--warning">
  If you still use the hub-spoke network topology even though your use-case marks the above points, you will end up with a complex network topology that is hard to manage and maintain. This will result in a higher cost and a less secure environment.
</div>

## Implement the hub-spoke network topology for SmartMoney
Like described <a href="/smartmoney">here</a>, OneFinance rushed to deploy workloads to the cloud during Corona so that employees could continue to work from home. Essential aspects like security, costs and maintainability were not given priority. The network topology is the heart of the infrastructure. OneFinance has many workloads that are or will be deployed to the cloud. Many of those workloads should only be accessible by employees.

Below the hub-spoke architecture for OneFinance and the SmartMoney workload. For now, I'll not go into detail about the different services that are deployed to the hub and spokes. These details will be covered in upcoming articles.

<img src="/assets/diagrams/smartmoney-hub-spoke-network-topology.drawio.png"  />

Two virtual networks (vnets) are deployed, one for the hub and one for the SmartMoney workload. Connectivity is established by peering the networks. As you can see in the architecture, spokes benefit from the shared services in the hub. For example, the VPN gateway is deployed in the hub and allows traffic from onpremise to the spokes and vice versa. This reduces the cost and complexity of deploying a VPN gateway in each spoke.

### Terraform 
Using Infrastructure as Code is a best practice to reduce the risk of human error, ensure consistency, automation and save costs. In an upcoming article, I'll explain how infrastructure as code can help detect faults and security risks early in the devops process. For now, I'll show you the Terraform code that is used to deploy the hub-spoke network topology.

```terraform
resource "azurerm_virtual_network" "vnet_hub" {
  name                = "vnet-hub"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_hub.location
  resource_group_name = azurerm_resource_group.rg_hub.name
}

resource "azurerm_virtual_network" "vnet_smartmoney" {
  name                = "vnet-smartmoney"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.rg_smartmoney.location
  resource_group_name = azurerm_resource_group.rg_smartmoney.name

  subnet {
    name           = "snet-frontend"
    address_prefix = "10.1.0.0/20"
  }

  subnet {
    name           = "snet-backend"
    address_prefix = "10.1.16.0/20"
  }

  subnet {
    name           = "snet-private-endpoints"
    address_prefix = "10.1.32.0/20"
  }
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = "smartmoney-to-hub"
  resource_group_name          = azurerm_resource_group.rg_smartmoney.name
  virtual_network_name         = azurerm_virtual_network.vnet_smartmoney.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet_hub.id
}
```

The Terraform code is available in the <a href="https://github.com/patkleef/zero-trust/tree/main/infra" target="_blank">github.com/patkleef/zero-trust</a> repository. With each article, I will make updates to the source code.

## Zero Trust principles

The network topology serves as the foundation for bringing workloads to the cloud. In the upcoming articles, I'll expand the architecture with additional services to ensure the security of both the infrastructure and SmartMoney application by following the Zero Trust principles.

## What is next?
- In the next article, I'll create the PaaS (app services, SQL database, storage account) services for the SmartMoney application and explain how you can protect them with Azure Private Link.
