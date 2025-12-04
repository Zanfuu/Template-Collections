#!/bin/bash

# Update dan upgrade sistem
sudo apt update && sudo apt upgrade -y

# Instal paket pendukung untuk repository
sudo apt install ca-certificates curl gnupg -y

# Tambahkan GPG key Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Tambahkan repository resmi Docker
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo $VERSION_CODENAME) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update daftar paket
sudo apt update

# Instal Docker Engine, containerd, dan Docker Compose
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Pastikan Docker berjalan
sudo systemctl enable --now docker
sudo systemctl is-active docker

# Tambahkan user ke grup docker
sudo usermod -aG docker $USER

echo "====================================================="
echo "Docker berhasil terinstall."
echo "Silakan logout dari VPS lalu login lagi."
echo "Setelah login ulang, jalankan:"
echo ""
echo "    docker run hello-world"
echo ""
echo "====================================================="