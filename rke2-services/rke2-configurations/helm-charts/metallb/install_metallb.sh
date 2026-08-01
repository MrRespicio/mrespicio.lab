#!/usr/bin/env bash

###############################################################################
# Ensure Helm Repository Exists
###############################################################################

echo "Checking MetalLB Helm repository..."

if ! helm repo list | grep -q "^metallb"; then
  echo "Adding MetalLB Helm repository..."

  helm repo add metallb https://metallb.github.io/metallb
fi

###############################################################################
# MetalLB Installation Procedure
#
# Purpose:
#   Install MetalLB platform components and configuration resources.
#
# Installation Order:
#   1. metallb-bootstrap
#   2. metallb-config
###############################################################################

set -e

###############################################################################
# Step 1: Install MetalLB Bootstrap
###############################################################################

echo "Installing MetalLB bootstrap components..."

(
  cd bootstrap
  ./install_metallb-bootstrap.sh
)

###############################################################################
# Step 2: Install MetalLB Configuration
###############################################################################

echo "Installing MetalLB configuration..."

(
  cd config
  ./install_metallb-config.sh
)

###############################################################################
# Complete
###############################################################################

echo "MetalLB installation completed successfully."