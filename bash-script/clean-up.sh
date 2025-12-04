#!/bin/sh

echo "=========================================="
echo "🐳 Mulai Proses Pembersihan Docker"
echo "=========================================="

# Menampilkan statistik penggunaan disk Docker sebelum pembersihan
echo "--- 📊 Status Docker Disk Sebelum Pruning ---"
docker system df

echo "------------------------------------------"
echo "⚠️ PERINGATAN! Ini akan menghapus:        "
echo "   - Semua kontainer yang berhenti.       "
echo "   - Semua jaringan yang tidak digunakan. "
echo "   - Semua image yang tidak terpakai      "
echo "     (kecuali yang digunakan kontainer).  "
echo "   - Semua cache build.                   "
echo "------------------------------------------"

    # Perintah utama untuk membersihkan
    # -a: Hapus semua image yang tidak digunakan (bukan hanya dangling/gantung)
    # -f: Paksa, tidak meminta konfirmasi

    echo "-> Menjalankan docker system prune -a -f..."
    docker system prune -a -f

    echo "--- ✅ Pembersihan Docker Selesai ---"

    # Menampilkan statistik penggunaan disk Docker setelah pembersihan
    echo "--- 📊 Status Docker Disk Setelah Pruning ---"
    docker system df