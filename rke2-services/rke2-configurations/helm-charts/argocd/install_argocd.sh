#!/usr/bin/env bash

###############################################################################
# Argo CD Bootstrap Installation Procedure
#
# Purpose:
#   Rebuild chart dependencies, validate the chart, and install Argo CD.
#
# Prerequisites:
#   - Kubernetes cluster is available
#   - Helm repository is reachable
#   - Istio is NOT required during bootstrap
#
# Notes:
#   Argo CD is installed first and will later manage Istio through GitOps.
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
# charts/*.tgz downloaded

###############################################################################
# Step 4: Validate Chart
###############################################################################

echo "Running helm lint..."

helm lint .

echo "Rendering manifests..."

helm template argocd .

###############################################################################
# Step 5: Install Chart
###############################################################################

echo "Installing chart..."

helm upgrade --install argocd . \
  -n argocd \
  --create-namespace \
  --wait

###############################################################################
# Verification
###############################################################################

echo "Checking Helm release..."

helm list -n argocd

echo "Checking Argo CD pods..."

kubectl get pods -n argocd

echo "Checking Argo CD services..."

kubectl get svc -n argocd

echo "Checking Argo CD CRDs..."

kubectl get crd | grep argoproj

###############################################################################
# Notes
###############################################################################

# Initial access to Argo CD can be performed using:
#
# kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo 
# 
# kubectl port-forward svc/argocd-server -n argocd 8080:80
#
# Once Istio is deployed and managed by Argo CD:
#
# 1. Create an Istio Gateway.
# 2. Create a VirtualService for Argo CD.
# 3. Access Argo CD through the Istio Ingress Gateway.
#
# Example:
#
# https://argocd.lab.local
#
# This bootstrap process intentionally avoids installing Istio.
# Istio should be deployed and managed by Argo CD after bootstrap.