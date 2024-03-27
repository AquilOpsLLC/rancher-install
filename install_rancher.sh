#!/bin/bash

# Install Helm (if not already installed)
command -v helm >/dev/null 2>&1 || { echo >&2 "Helm not found, installing..."; \
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3; \
chmod +x get_helm.sh; \
./get_helm.sh; \
rm get_helm.sh; }

# Add the Rancher Helm repository
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

# Create a namespace for Rancher
kubectl create namespace cattle-system

# Install Rancher
helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=rancher.example.com   # Change to your desired hostname

# Wait for Rancher to be ready
echo "Waiting for Rancher to be ready..."
while [[ $(kubectl -n cattle-system get pods -l app=rancher --no-headers | grep -c Running) -lt 1 ]]; do
  echo "Rancher is not ready yet, waiting..."
  sleep 10
done

# Print Rancher URL
echo "Rancher is now installed and running."
echo "You can access Rancher at: https://rancher.example.com"  # Change to your desired URL
