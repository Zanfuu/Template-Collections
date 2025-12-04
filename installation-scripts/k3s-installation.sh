#!/bin/bash

set -e

# ----------------------------
# Variabel
# ----------------------------
K3S_VERSION="v1.30.0+k3s1"
INSTALL_K3S_EXEC="--disable traefik --write-kubeconfig-mode 644"

# ----------------------------
# Update sistem
# ----------------------------
sudo apt update && sudo apt upgrade -y

# ----------------------------
# Install K3s Server
# ----------------------------
curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=$K3S_VERSION INSTALL_K3S_EXEC="$INSTALL_K3S_EXEC" sh -

# ----------------------------
# Verifikasi
# ----------------------------
sudo systemctl status k3s --no-pager
echo "====================================================="
echo "K3s Master berhasil terinstall!"
echo "Silahkan ganti IP Server dengan IP VPS Anda"
echo "cat /etc/rancher/k3s/k3s.yaml"
echo ""
echo "====================================================="
echo ""
echo "Uji koneksi K3s dengan perintah:"
echo "kubectl --kubeconfig=~/.kube/k3s.yaml get nodes"
echo ""
echo "====================================================="