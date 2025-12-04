# Zanfuu-Template-Collections

Koleksi template deployment untuk berbagai aplikasi dan services menggunakan Docker Compose dan bash scripts. Template ini dirancang untuk mempermudah setup infrastruktur dengan konfigurasi yang fleksibel dan production-ready.

## 📁 Struktur Repository

```
Template-Collections/
├── services/                    # Template deployment untuk berbagai services
│   ├── monitoring-grafana/     # Prometheus & Node Exporter
│   ├── MySQL/                  # Database MySQL
│   ├── n8n/                    # Workflow automation platform
│   ├── nginx-proxy-manager/    # Reverse proxy dengan/ tanpa MySQL
│   ├── portainer/              # Docker management UI
│   ├── PostgreSQL/             # Database PostgreSQL
│   ├── Redis/                  # Cache Redis
│   └── wordpress/              # WordPress standalone & dengan MySQL
├── installation-scripts/        # Script instalasi dependencies
│   ├── docker-installation.sh  # Instalasi Docker & Docker Compose
│   └── k3s-installation.sh     # Instalasi K3s Kubernetes
└── bash-script/                 # Utility scripts
    └── clean-up.sh             # Pembersihan Docker yang tidak terpakai
```

## 🚀 Quick Start

### Prasyarat

- **OS**: Ubuntu 20.04/22.04 atau Debian-based Linux
- **Docker**: Versi terbaru (install via `installation-scripts/docker-installation.sh`)
- **Docker Compose**: Plugin terbaru (termasuk dalam instalasi Docker)

### Setup Awal

1. **Install Docker & Docker Compose**:
   ```bash
   bash installation-scripts/docker-installation.sh
   ```

2. **Buat Docker Network** (jika menggunakan template yang memerlukan network eksternal):
   ```bash
   docker network create nginx-proxy-manager_default
   ```

3. **Pilih dan setup service**:
   ```bash
   cd services/[nama-service]
   docker-compose up -d
   ```

## 📦 Available Services

### 🐳 Docker Management

#### Portainer
- **Lokasi**: `services/portainer/`
- **Port**: 9443 (HTTPS), 8000 (Edge Agent)
- **Deskripsi**: Web UI untuk manajemen Docker containers, images, volumes, dan networks
- **Features**: 
  - Support network eksternal atau standalone
  - HTTPS enabled by default
  - Edge Agent support untuk remote management

### 🔄 Reverse Proxy

#### Nginx Proxy Manager
- **Lokasi**: `services/nginx-proxy-manager/`
- **Variants**:
  - `docker-compose.yml` - Standalone (SQLite)
  - `with-mySQL/docker-compose.yml` - Dengan MySQL database
- **Port**: 80 (HTTP), 443 (HTTPS), 81 (Admin Panel)
- **Deskripsi**: Reverse proxy dengan web UI untuk manajemen domain dan SSL certificates

### 💾 Databases

#### MySQL
- **Lokasi**: `services/MySQL/`
- **Port**: 3306
- **Image**: `mysql:8.0`
- **Features**:
  - Volume persistence
  - Custom database & user setup
  - Root password configuration

#### PostgreSQL
- **Lokasi**: `services/PostgreSQL/`
- **Port**: 5432
- **Image**: `postgres:15-alpine`
- **Features**:
  - Environment variables (2 opsi: langsung atau dari file .env)
  - Volume persistence
  - Network eksternal support

#### Redis
- **Lokasi**: `services/Redis/`
- **Port**: 6379
- **Image**: `redis:7-alpine`
- **Deskripsi**: In-memory data structure store untuk caching dan session management

### 🌐 Web Applications

#### WordPress
- **Lokasi**: `services/wordpress/`
- **Variants**:
  - `docker-compose.yml` - Standalone (menggunakan DB eksternal)
  - `wordpress-with-mysql/docker-compose.yml` - Lengkap dengan MySQL
- **Port**: 8080
- **Features**:
  - Volume persistence untuk wp-content
  - Environment variables configuration (2 opsi)
  - Network eksternal support

### 🤖 Automation & Workflow

#### n8n
- **Lokasi**: `services/n8n/`
- **Port**: 5678
- **Image**: `n8n.io/n8n`
- **Deskripsi**: Platform workflow automation untuk mengotomasi task dan integrasi
- **Features**:
  - Support PostgreSQL atau MySQL sebagai database
  - Basic authentication
  - Volume persistence untuk workflows
  - Environment variables configuration (2 opsi)
  - Network eksternal support
- **Catatan**: Memerlukan database (PostgreSQL/MySQL) yang sudah running

### 📊 Monitoring

#### Prometheus Stack
- **Lokasi**: `services/monitoring-grafana/`
- **Services**:
  - **Prometheus**: Port 9090 - Metrics collection dan storage
  - **Node Exporter**: Port 9100 - System metrics exporter
- **Deskripsi**: Monitoring stack untuk mengumpulkan dan menyimpan metrics
- **Features**:
  - Prometheus configuration file
  - System metrics collection (CPU, memory, disk, network)
  - Network eksternal support

## 🔧 Installation Scripts

### Docker Installation
Instalasi Docker Engine, Docker CLI, dan Docker Compose plugin untuk Ubuntu/Debian.

```bash
bash installation-scripts/docker-installation.sh
```

**Apa yang diinstall**:
- Docker Engine
- Docker CLI
- Docker Compose Plugin
- Containerd
- Docker Buildx

**Catatan**: Setelah instalasi, logout dan login kembali untuk aktivasi grup docker. Verifikasi dengan:
```bash
docker run hello-world
```

### K3s Installation
Instalasi K3s (lightweight Kubernetes distribution).

```bash
bash installation-scripts/k3s-installation.sh
```

**Versi**: v1.30.0+k3s1
**Features**: Disabled Traefik (bisa setup sendiri)
**Post-installation**: 
- Copy kubeconfig: `cat /etc/rancher/k3s/k3s.yaml`
- Test koneksi: `kubectl get nodes`

## 🛠️ Utility Scripts

### Docker Clean Up
Membersihkan container, image, network, dan cache Docker yang tidak terpakai.

```bash
bash bash-script/clean-up.sh
```

**Apa yang dibersihkan**:
- Stopped containers
- Unused networks
- Dangling images
- Build cache

**⚠️ Warning**: Script ini akan menghapus semua yang tidak digunakan. Pastikan tidak ada data penting yang akan hilang.

**Output**: Menampilkan statistik disk usage sebelum dan sesudah pembersihan.

## ⚙️ Konfigurasi Services

### Environment Variables

Kebanyakan template menyediakan 2 opsi konfigurasi:

1. **Environment langsung di docker-compose.yml** (Aktif)
   - Quick setup
   - Nilai default sudah disediakan
   - Cocok untuk development/testing

2. **Environment dari file .env terpisah** (Opsional)
   - Lebih aman untuk production
   - Copy `env.example` ke `.env` dan sesuaikan
   - Tidak ter-commit ke repository

**Cara menggunakan .env**:
```bash
# Di direktori service
cp env.example .env
# Edit .env sesuai kebutuhan
# Comment environment di docker-compose.yml
# Uncomment env_file section
docker-compose up -d
```

### Network Configuration

Beberapa template menggunakan network eksternal `nginx-proxy-manager_default`. Pastikan network sudah dibuat:

```bash
docker network create nginx-proxy-manager_default
```

Atau ubah konfigurasi di docker-compose.yml untuk menggunakan network default/standalone.

**Manfaat network eksternal**:
- Multiple services bisa berkomunikasi
- Reverse proxy bisa route ke services
- Isolasi dan security yang lebih baik

## 📝 Usage Examples

### Setup WordPress dengan MySQL

```bash
cd services/wordpress/wordpress-with-mysql

# Opsi 1: Gunakan konfigurasi default
docker-compose up -d

# Opsi 2: Gunakan file .env
cp env.example .env
# Edit .env sesuai kebutuhan
# Update docker-compose.yml untuk menggunakan env_file
docker-compose up -d

# Akses WordPress:
# http://localhost:8080
```

### Setup Portainer

```bash
cd services/portainer
docker-compose up -d

# Akses via browser:
# https://localhost:9443
```

### Setup n8n dengan PostgreSQL

```bash
# Pastikan PostgreSQL sudah running
cd services/PostgreSQL
docker-compose up -d

# Setup n8n
cd ../n8n
docker-compose up -d

# Akses n8n:
# http://localhost:5678
# Login dengan credentials di docker-compose.yml
```

### Setup Monitoring Stack

```bash
cd services/monitoring-grafana
docker-compose up -d

# Akses Prometheus:
# http://localhost:9090
# 
# Node Exporter metrics:
# http://localhost:9100/metrics
```

### Setup Nginx Proxy Manager

```bash
# Standalone version
cd services/nginx-proxy-manager
docker-compose up -d

# Atau dengan MySQL
cd services/nginx-proxy-manager/with-mySQL
docker-compose up -d

# Akses admin panel:
# http://localhost:81
# Default login: admin@example.com / changeme
```

## ⚠️ Security Best Practices

1. **Ganti Password Default**
   - Selalu ganti password default sebelum production
   - Gunakan password yang kuat dan unik (minimal 12 karakter, kombinasi huruf, angka, simbol)
   - Jangan gunakan password yang sama untuk multiple services

2. **Gunakan Environment Variables**
   - Jangan commit file `.env` ke git
   - Gunakan `.env.example` sebagai template
   - Rotate credentials secara berkala

3. **Firewall Configuration**
   - Batasi port yang terbuka
   - Hanya expose port yang diperlukan
   - Gunakan firewall rules untuk membatasi akses

4. **Regular Updates**
   - Update Docker images secara berkala
   - Monitor security advisories
   - Gunakan specific version tags, bukan `latest`

5. **Backup Data**
   - Backup volume data secara rutin
   - Simpan backup di lokasi aman (external storage)
   - Test restore process secara berkala

6. **Network Security**
   - Gunakan network isolation untuk production
   - Jangan expose database port ke internet
   - Gunakan reverse proxy untuk SSL/TLS termination

## 🔗 Network Setup

Jika menggunakan multiple services dengan reverse proxy, pastikan mereka dalam network yang sama:

```bash
# Buat network (sekali saja)
docker network create nginx-proxy-manager_default

# Services yang menggunakan network ini akan otomatis terhubung
# Cek network:
docker network ls
docker network inspect nginx-proxy-manager_default
```

**Services yang menggunakan network eksternal**:
- Portainer
- PostgreSQL
- Redis
- WordPress
- n8n
- Prometheus Stack

## 🐛 Troubleshooting

### Container tidak bisa start
```bash
# Cek logs
docker-compose logs [service-name]

# Cek status container
docker-compose ps

# Cek resource usage
docker stats
```

### Port sudah digunakan
```bash
# Cek port yang digunakan
sudo netstat -tulpn | grep [port-number]

# Atau gunakan
sudo lsof -i :[port-number]

# Stop service yang menggunakan port atau ubah port di docker-compose.yml
```

### Network tidak ditemukan
```bash
# Buat network
docker network create nginx-proxy-manager_default

# Atau ubah ke network default di docker-compose.yml
```

### Volume permission denied
```bash
# Fix permission untuk volume
sudo chown -R $USER:$USER [volume-path]
# Atau gunakan volume named (direkomendasikan)
```

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Portainer Documentation](https://docs.portainer.io/)
- [Nginx Proxy Manager](https://nginxproxymanager.com/)
- [n8n Documentation](https://docs.n8n.io/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [WordPress Docker Documentation](https://hub.docker.com/_/wordpress)

## 🤝 Contributing

Kontribusi sangat diterima! Jika ada template atau improvement yang ingin ditambahkan:

1. Fork repository
2. Buat branch untuk fitur baru (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

**Guidelines**:
- Ikuti struktur folder yang ada
- Sertakan dokumentasi yang jelas
- Test template sebelum submit
- Update README jika menambahkan service baru

## 📄 License

Template ini bebas digunakan untuk keperluan personal maupun komersial.

## 👤 Author

**Zanfuu**

---

⭐ Jika repository ini membantu, jangan lupa beri star!

📝 **Note**: Pastikan untuk membaca dokumentasi setiap service sebelum menggunakannya di production.
