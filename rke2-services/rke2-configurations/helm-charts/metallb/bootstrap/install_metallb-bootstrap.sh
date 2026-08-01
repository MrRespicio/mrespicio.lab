#!/usr/bin/env bash

###############################################################################
# MetalLB Bootstrap Rebuild Procedure
#
# Purpose:
#   Rebuild chart dependencies and prepare for a fresh installation.
###############################################################################

set -e

###############################################################################
# Step 1: Remove Existing Dependencies
###############################################################################

echo "Removing existing dependency artifacts..."

rm -f Chart.lock
rm -rf charts

###############################################################################
# Step 2: Refresh Helm Repositories
###############################################################################

echo "Refreshing Helm repositories..."

helm repo update

###############################################################################
# Step 3: Download Dependencies
###############################################################################

echo "Downloading chart dependencies..."

helm dependency update

###############################################################################
# Expected Result
###############################################################################

# Chart.lock created
# charts/metallb-0.15.3.tgz downloaded

###############################################################################
# Step 4: Validate Chart
###############################################################################

echo "Running helm lint..."

helm lint .

echo "Rendering manifests..."

helm template metallb-bootstrap .

###############################################################################
# Step 5: Install Chart
###############################################################################

echo "Installing chart..."

helm upgrade --install metallb . \
  -n metallb-system \
  --create-namespace \
  --wait

###############################################################################
# Verification
###############################################################################

echo "Checking release..."

helm list -n metallb-system

echo "Checking MetalLB pods..."

kubectl get pods -n metallb-system

echo "Checking MetalLB CRDs..."

kubectl get crd | grep metallb

###############################################################################
# Notes
###############################################################################

# If installation fails with:
#
# no matches for kind "IPAddressPool"
# no matches for kind "L2Advertisement"
#
# Then IPAddressPool/L2Advertisement templates are being rendered
# before the MetalLB CRDs exist.
#
# Resolution:
#
# 1. Install MetalLB first.
# 2. Apply IPAddressPool and L2Advertisement afterwards.
# 3. Or separate MetalLB and MetalLB configuration into two charts.
