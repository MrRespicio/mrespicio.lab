#!/usr/bin/env bash

###############################################################################
# MetalLB Uninstallation Procedure
#
# Purpose:
#   Remove MetalLB configuration resources and platform components.
#
# Uninstallation Order:
#   1. metallb-config
#   2. metallb-bootstrap
###############################################################################

set -e

###############################################################################
# Step 1: Uninstall MetalLB Configuration
###############################################################################

echo "Uninstalling MetalLB configuration..."

(
  cd config
  ./uninstall_metallb-config.sh
)

###############################################################################
# Step 2: Uninstall MetalLB Bootstrap
###############################################################################

echo "Uninstalling MetalLB bootstrap components..."

(
  cd bootstrap
  ./uninstall_metallb-bootstrap.sh
)


###############################################################################
# Complete
###############################################################################

echo "MetalLB uninstallation completed successfully."

echo
echo "Optional Cleanup:"
echo "  kubectl delete namespace metallb-system"
echo "  kubectl get crd | grep metallb.io | awk '{print \$1}' | xargs kubectl delete crd"