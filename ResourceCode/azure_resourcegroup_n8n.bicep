param virtualMachines_n8n_vm_name string = 'n8n-vm'
param virtualMachines_zapier_vm_name string = 'zapier-vm'
param networkInterfaces_n8n_vm262_name string = 'n8n-vm262'
param publicIPAddresses_n8n_vm_ip_name string = 'n8n-vm-ip'
param virtualNetworks_n8n_vm_vnet_name string = 'n8n-vm-vnet'
param publicIPAddresses_zapier_vm_pip_name string = 'zapier-vm-pip'
param bastionHosts_n8n_vm_vnet_bastion_name string = 'n8n-vm-vnet-bastion'
param networkInterfaces_zapier_vmVMNic_name string = 'zapier-vmVMNic'
param networkSecurityGroups_n8n_vm_nsg_name string = 'n8n-vm-nsg'
param networkSecurityGroups_zapier_vm_nsg_name string = 'zapier-vm-nsg'
param workspaces_n8n_test_loga_name string = 'n8n-test-loga'
param storageAccounts_n8ncreativeprompting_name string = 'n8ncreativeprompting'
param schedules_shutdown_computevm_n8n_vm_name string = 'shutdown-computevm-n8n-vm'
param schedules_shutdown_computevm_zapier_vm_name string = 'shutdown-computevm-zapier-vm'
param privateEndpoints_pen8ncretivepromptingstorage_name string = 'pen8ncretivepromptingstorage'
param privateDnsZones_privatelink_blob_core_windows_net_name string = 'privatelink.blob.core.windows.net'
param metricAlerts_n8ncreativeprompting_AvailabilityAlert_name string = 'n8ncreativeprompting-AvailabilityAlert'

resource networkSecurityGroups_n8n_vm_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2025-05-01' = {
  name: networkSecurityGroups_n8n_vm_nsg_name
  location: 'westeurope'
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 300
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'n8n-frontend-public'
        properties: {
          description: 'Reach frontend under http://20.224.73.40:5678/'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '5678'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 111
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'Allow-HTTP-80'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1010
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'Allow-HTTPS-443'
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1020
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource privateDnsZones_privatelink_blob_core_windows_net_name_resource 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZones_privatelink_blob_core_windows_net_name
  location: 'global'
  properties: {}
}

resource publicIPAddresses_n8n_vm_ip_name_resource 'Microsoft.Network/publicIPAddresses@2025-05-01' = {
  name: publicIPAddresses_n8n_vm_ip_name
  location: 'westeurope'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.224.73.40'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource virtualNetworks_n8n_vm_vnet_name_resource 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: virtualNetworks_n8n_vm_vnet_name
  location: 'westeurope'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'n8n-snet'
        properties: {
          addressPrefix: '10.10.10.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource storageAccounts_n8ncreativeprompting_name_resource 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: storageAccounts_n8ncreativeprompting_name
  location: 'westeurope'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_0'
    allowBlobPublicAccess: false
    networkAcls: {
      ipv6Rules: []
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource virtualMachines_n8n_vm_name_resource 'Microsoft.Compute/virtualMachines@2025-11-01' = {
  name: virtualMachines_n8n_vm_name
  location: 'westeurope'
  tags: {
    Hosted_URL: 'http://20.224.73.40:5678'
    api_key: '$openai-key'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D4s_v3'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_n8n_vm_name}_OsDisk_1_266918c899c84a22a2d068391fae231c'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_n8n_vm_name}_OsDisk_1_266918c899c84a22a2d068391fae231c'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_n8n_vm_name
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'psasse'
    }
    securityProfile: {
      securityType: 'Standard'
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource bastionHosts_n8n_vm_vnet_bastion_name_resource 'Microsoft.Network/bastionHosts@2025-05-01' = {
  name: bastionHosts_n8n_vm_vnet_bastion_name
  location: 'westeurope'
  sku: {
    name: 'Developer'
  }
  properties: {
    dnsName: 'omnibrain.westeurope.bastionglobal.azure.com'
    scaleUnits: 2
    virtualNetwork: {
      id: virtualNetworks_n8n_vm_vnet_name_resource.id
    }
    ipConfigurations: []
  }
}

resource networkSecurityGroups_n8n_vm_nsg_name_Allow_HTTP_80 'Microsoft.Network/networkSecurityGroups/securityRules@2025-05-01' = {
  name: '${networkSecurityGroups_n8n_vm_nsg_name}/Allow-HTTP-80'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '80'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 1010
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_n8n_vm_nsg_name_resource
  ]
}

resource networkSecurityGroups_n8n_vm_nsg_name_Allow_HTTPS_443 'Microsoft.Network/networkSecurityGroups/securityRules@2025-05-01' = {
  name: '${networkSecurityGroups_n8n_vm_nsg_name}/Allow-HTTPS-443'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '443'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 1020
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_n8n_vm_nsg_name_resource
  ]
}

resource networkSecurityGroups_n8n_vm_nsg_name_n8n_frontend_public 'Microsoft.Network/networkSecurityGroups/securityRules@2025-05-01' = {
  name: '${networkSecurityGroups_n8n_vm_nsg_name}/n8n-frontend-public'
  properties: {
    description: 'Reach frontend under http://20.224.73.40:5678/'
    protocol: '*'
    sourcePortRange: '*'
    destinationPortRange: '5678'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 111
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_n8n_vm_nsg_name_resource
  ]
}

resource networkSecurityGroups_n8n_vm_nsg_name_SSH 'Microsoft.Network/networkSecurityGroups/securityRules@2025-05-01' = {
  name: '${networkSecurityGroups_n8n_vm_nsg_name}/SSH'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 300
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_n8n_vm_nsg_name_resource
  ]
}

resource privateDnsZones_privatelink_blob_core_windows_net_name_n8ncreativeprompting 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_privatelink_blob_core_windows_net_name_resource
  name: 'n8ncreativeprompting'
  properties: {
    metadata: {
      creator: 'created by private endpoint pen8ncretivepromptingstorage with resource guid 508ce7b3-5a6c-4c37-9f12-7910321ef226'
    }
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.10.10.5'
      }
    ]
  }
}

resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_privatelink_blob_core_windows_net_name 'Microsoft.Network/privateDnsZones/SOA@2024-06-01' = {
  parent: privateDnsZones_privatelink_blob_core_windows_net_name_resource
  name: '@'
  properties: {
    ttl: 3600
    soaRecord: {
      email: 'azureprivatedns-host.microsoft.com'
      expireTime: 2419200
      host: 'azureprivatedns.net'
      minimumTtl: 10
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
  }
}

resource virtualNetworks_n8n_vm_vnet_name_n8n_snet 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  name: '${virtualNetworks_n8n_vm_vnet_name}/n8n-snet'
  properties: {
    addressPrefix: '10.10.10.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_n8n_vm_vnet_name_resource
  ]
}

resource storageAccounts_n8ncreativeprompting_name_default 'Microsoft.Storage/storageAccounts/blobServices@2026-04-01' = {
  parent: storageAccounts_n8ncreativeprompting_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    staticWebsite: {
      enabled: false
    }
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: false
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_n8ncreativeprompting_name_default 'Microsoft.Storage/storageAccounts/fileServices@2026-04-01' = {
  parent: storageAccounts_n8ncreativeprompting_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {}
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource storageAccounts_n8ncreativeprompting_name_storageAccounts_n8ncreativeprompting_name_8c485c62_deb7_486a_9b69_6897f51ccb13 'Microsoft.Storage/storageAccounts/privateEndpointConnections@2026-04-01' = {
  parent: storageAccounts_n8ncreativeprompting_name_resource
  name: '${storageAccounts_n8ncreativeprompting_name}.8c485c62-deb7-486a-9b69-6897f51ccb13'
  properties: {
    privateEndpoint: {}
    privateLinkServiceConnectionState: {
      status: 'Approved'
      description: 'Auto-Approved'
      actionRequired: 'None'
    }
  }
}

resource privateDnsZones_privatelink_blob_core_windows_net_name_uerac3jhz5ws4 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZones_privatelink_blob_core_windows_net_name_resource
  name: 'uerac3jhz5ws4'
  location: 'global'
  properties: {
    registrationEnabled: false
    resolutionPolicy: 'Default'
    virtualNetwork: {
      id: virtualNetworks_n8n_vm_vnet_name_resource.id
    }
  }
}

resource privateEndpoints_pen8ncretivepromptingstorage_name_resource 'Microsoft.Network/privateEndpoints@2025-05-01' = {
  name: privateEndpoints_pen8ncretivepromptingstorage_name
  location: 'westeurope'
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpoints_pen8ncretivepromptingstorage_name
        properties: {
          privateLinkServiceId: storageAccounts_n8ncreativeprompting_name_resource.id
          groupIds: [
            'blob'
          ]
          privateLinkServiceConnectionState: {
            status: 'Approved'
            description: 'Auto-Approved'
            actionsRequired: 'None'
          }
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    customNetworkInterfaceName: '${privateEndpoints_pen8ncretivepromptingstorage_name}-nic'
    subnet: {
      id: virtualNetworks_n8n_vm_vnet_name_n8n_snet.id
    }
    ipConfigurations: []
    customDnsConfigs: []
    ipVersionType: 'IPv4'
  }
}

resource privateEndpoints_pen8ncretivepromptingstorage_name_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2025-05-01' = {
  name: '${privateEndpoints_pen8ncretivepromptingstorage_name}/default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-blob-core-windows-net'
        properties: {
          privateDnsZoneId: privateDnsZones_privatelink_blob_core_windows_net_name_resource.id
        }
      }
    ]
  }
  dependsOn: [
    privateEndpoints_pen8ncretivepromptingstorage_name_resource
  ]
}

resource storageAccounts_n8ncreativeprompting_name_default_ai_generated_artifacts 'Microsoft.Storage/storageAccounts/blobServices/containers@2026-04-01' = {
  parent: storageAccounts_n8ncreativeprompting_name_default
  name: 'ai-generated-artifacts'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_n8ncreativeprompting_name_resource
  ]
}

resource networkInterfaces_n8n_vm262_name_resource 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: networkInterfaces_n8n_vm262_name
  location: 'westeurope'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: '10.10.10.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_n8n_vm_ip_name_resource.id
            properties: {
              deleteOption: 'Delete'
            }
          }
          subnet: {
            id: virtualNetworks_n8n_vm_vnet_name_n8n_snet.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroups_n8n_vm_nsg_name_resource.id
    }
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}
