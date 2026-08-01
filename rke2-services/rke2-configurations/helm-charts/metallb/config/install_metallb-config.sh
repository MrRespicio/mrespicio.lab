#!/usr/bin/env bash

###############################################################################
# MetalLB Config Installation Procedure
#
# Purpose:
#   Install MetalLB configuration resources such as:
#   - IPAddressPool
#   - L2Advertisement
#
# Prerequisite:
#   MetalLB platform must already be installed and its CRDs available.
###############################################################################

set -e

###############################################################################
# Step 1: Verify MetalLB CRDs Exist
###############################################################################

echo "Checking MetalLB CRDs..."

kubectl get crd ipaddresspools.metallb.io >/dev/null
kubectl get crd l2advertisements.metallb.io >/dev/null

echo "MetalLB CRDs found."

###############################################################################
# Step 2: Validate Chart
###############################################################################

echo "Running helm lint..."

helm lint .

echo "Rendering manifests..."

helm template metallb-config .

###############################################################################
# Step 3: Install Chart
###############################################################################

echo "Installing chart..."

helm upgrade --install metallb-config . \
  -n metallb-system \
  --create-namespace \
  --wait

###############################################################################
# Verification
###############################################################################

echo "Checking release..."

helm list -n metallb-system

echo "Checking IPAddressPools..."

kubectl get ipaddresspools -n metallb-system

echo "Checking L2Advertisements..."

kubectl get l2advertisements -n metallb-system

###############################################################################
# Notes
###############################################################################

# If the following error occurs:
#
# no matches for kind "IPAddressPool"
# no matches for kind "L2Advertisement"
#
# Then MetalLB CRDs are not available.
#
# Resolution:
#
# 1. Install the metallb-platform chart first.
# 2. Verify CRDs exist:
#
#    kubectl get crd | grep metallb
#
# 3. Re-run this script.