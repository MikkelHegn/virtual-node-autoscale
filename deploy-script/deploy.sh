#!/bin/bash

# Install Virtual Node
## Step 1 - create a subnet
set RG=aks-vn
set CLUSTERNAME=aks-vn
set SUBNETNAME=vn-subnet

MCGROUP=$(az aks show -g aks-vn -n aks-vn -o tsv --query nodeResourceGroup)
VNETNAME=$(az network vnet list -g $MCGROUP -o tsv --query '[0].name')

az network vnet subnet create -n $SUBNETNAME --address-prefixes 10.230.0.0/16 -g $MCGROUP -n $VNETNAME --delegations Microsoft.ContainerInstance/containerGroups

## Step 2 - Enable VN
az aks enable-addons -g $RG -n $CLUSTERNAME --addons virtual-node --subnet-name $SUBNETNAME

# Get lastest Helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Install admission controller