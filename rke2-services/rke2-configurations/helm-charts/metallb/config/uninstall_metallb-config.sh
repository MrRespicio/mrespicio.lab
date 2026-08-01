#!/usr/bin/env bash

###############################################################################
# MetalLB Config Uninstallation Procedure
#
# Purpose:
#   Remove MetalLB configuration resources managed by the metallb-config chart.
###############################################################################

set -e

###############################################################################
# Step 1: Uninstall Helm Release
###############################################################################

echo "Uninstalling chart..."

helm uninstall metallb-config -n metallb-system --wait

###############################################################################
# Verification
###############################################################################

echo "Checking release..."

helm list -n metallb-system

echo "Checking IPAddressPools..."

kubectl get ipaddresspools -n metallb-system || true

echo "Checking L2Advertisements..."

kubectl get l2advertisements -n metallb-system || true

###############################################################################
# Notes
###############################################################################

# This script removes:
# - IPAddressPool
# - L2Advertisement
#
# This script does NOT remove:
# - MetalLB Controller
# - MetalLB Speaker
# - MetalLB CRDs
# - metallb-system namespace
#
# To remove the MetalLB platform itself,
# uninstall the metallb-platform release separately.