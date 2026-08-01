#!/usr/bin/env bash

###############################################################################
# Argo CD Bootstrap Removal Procedure
#
# Purpose:
#   Remove the Argo CD Helm release and associated namespace.
###############################################################################

set -e

###############################################################################
# Step 1: Uninstall Helm Release
###############################################################################

echo "Removing Argo CD Helm release..."

helm uninstall argocd \
  -n argocd

###############################################################################
# Step 2: Remove Namespace
###############################################################################

echo "Removing Argo CD namespace..."

kubectl delete namespace argocd \
  --ignore-not-found=true

###############################################################################
# Step 3: Optional CRD Cleanup
###############################################################################

# Helm intentionally preserves Argo CD CRDs.
#
# Uncomment these commands if a complete cleanup is required.
#
kubectl delete crd applications.argoproj.io
kubectl delete crd applicationsets.argoproj.io
kubectl delete crd appprojects.argoproj.io

###############################################################################
# Verification
###############################################################################

echo "Checking Helm releases..."

helm list -A | grep argocd || true

echo "Checking namespaces..."

kubectl get ns | grep argocd || true

echo "Checking Argo CD CRDs..."

kubectl get crd | grep argoproj || true

###############################################################################
# Notes
###############################################################################

# CRDs are intentionally preserved by default because they may contain:
#
# - Applications
# - ApplicationSets
# - AppProjects
#
# Delete them only when performing a full cluster cleanup.