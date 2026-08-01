#!/usr/bin/env bash

###############################################################################
# MetalLB Platform Uninstallation Procedure
#
# Purpose:
#   Remove the MetalLB platform components managed by the metallb release.
#
# Components Removed:
#   - MetalLB Controller
#   - MetalLB Speaker
#   - MetalLB Helm Release
###############################################################################

set -e

###############################################################################
# Step 1: Uninstall Helm Release
###############################################################################

echo "Uninstalling chart..."

helm uninstall metallb -n metallb-system --wait

###############################################################################
# Verification
###############################################################################

echo "Checking release..."

helm list -n metallb-system

echo "Checking MetalLB pods..."

kubectl get pods -n metallb-system || true

###############################################################################
# Notes
###############################################################################

# This script removes:
# - MetalLB Helm Release
# - Controller Deployment
# - Speaker DaemonSet
#
# This script does NOT remove:
# - MetalLB CRDs
# - metallb-system namespace
#
# To remove MetalLB CRDs:
#
# kubectl get crd | grep metallb.io
#
# kubectl get crd | grep metallb.io | \
#   awk '{print $1}' | \
#   xargs kubectl delete crd
#
# To remove the namespace:
#
# kubectl delete namespace metallb-system
#
# To remove MetalLB configuration resources,
# uninstall the metallb-config release separately.