# Shipment Worksheet

Worksheet that enables a user to asign available inventory to outstanding sales orders.

[[_TOC_]]

## Purpose

Handling a multiple sales orders with a limited inventory poses a challenge. Assignment of inventory and prioritizing sales orders can be cumbersome.

In order to facilitate this process, a Shipment Worksheet can be a usefull tool. The worksheets are set up per location and canbe filled with outstanding sales order lines for the location. Allocation of inventory can be done by defining priorities or the be done manually. When the allocation is done it is made final by creating warehouse/inventory documents for those sales order lines.

For further information, please consult the included [documentation](someDocumentInDocumentFolder) and [Sharepoint](someDocumentOnSharepoint)

## Version

- 1.0.0.0 - Bill Gates
  - #2

## Prerequisites

- Business Central minimal version:
  >Platform 14.0.29530.0 + Application 29537 (BE Dynamics NAV 14.0)

- Extension dependancies:
  - [Extended Shipment Advice v2.0.0.1](linkToAzureRepo)
  - [Sales and Inventory Forecast v2.0.22794.0](https://appsource.microsoft.com/en-us/product/dynamics-365-business-central/PUBID.microsoftdynsmb%7CAID.aa5bced8-312d-4034-bfe2-e43e9ede9299%7CPAPPID.c526b3e9-b8ca-4683-81ba-fcd5f6b1472a?tab=Reviews)

- Azure Functionality
  - Azure Functions
    - [Print DHL Label](http://)

## Deployment

- Install the extension with PowerShell script:
  
  ```PowerShell
  Publish-NAVApp -ServerInstance YourDynamicsNAVServer -Path ".\ShipmentWorksheet.app"
  Sync-NavApp -ServerInstance YourDynamicsNAVServer -Name "Shipment Worksheet" -Path “.\ShipmentWorksheet.app” -Tenant TenantID
  ```

- Deploy dll's from the DotNet folder to:
  
  ```PowerShell
  <<Drive>>\Program Files\Microsoft Dynamics 365 Business Central\<<Version>>\Service\Add-Ins\
  ```

>Alternative1: For further information, please consult the included [documentation](someDocumentInDocumentFolder).
>
>Alternative2: For further information, please consult [Sharepoint](someDocumentOnSharepoint)

## Setup

- Setup a Warehouse Worksheet Template of the type "Shipment" for the locations where the Shipment Worksheet will be used.
- Import the RapidStart package "InitSetup.rapidstart" from the documentation folder.

>Alternative1: For further information, please consult the included [documentation](someDocumentInDocumentFolder).
>
>Alternative2: For further information, please consult [Sharepoint](someDocumentOnSharepoint)

## Contributing

Respect the [folder structure](FOLDERS.MD) in this repo.

Please consult the [guidelines](https://dev.azure.com/BroadHorizonBE/Minerva/_wiki/wikis/Minerva?wikiVersion=GBmaster&pageId=48&pagePath=%2FREADME) about Extension Development

Example of a [README](EXAMPLE.MD)