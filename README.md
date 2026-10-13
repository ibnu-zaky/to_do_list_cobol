# Daftar Tugas COBOL

Aplikasi daftar tugas sederhana berbasis terminal yang ditulis dengan COBOL. Tugas disimpan di `tasks.dat`, sehingga tetap tersedia saat aplikasi dibuka lagi.

## Quick start

### Persyaratan

- Linux atau lingkungan terminal yang kompatibel
- [GnuCOBOL](https://gnucobol.sourceforge.io/) (`cobc`)

Di Debian atau Ubuntu, pasang GnuCOBOL dengan:

```bash
sudo apt update
sudo apt install gnucobol
```

### Build dan jalankan

Dari direktori proyek, kompilasi source lalu jalankan aplikasinya:

```bash
cobc -x -o todo todo.cob
./todo
```

Jika executable `todo` sudah tersedia dan cocok dengan sistem Anda, jalankan langsung:

```bash
./todo
```

## Penggunaan

Pilih nomor menu berikut:

1. Tambah tugas
2. Lihat tugas
3. Tandai tugas selesai
4. Hapus tugas
5. Keluar

Data disimpan di `tasks.dat` pada direktori kerja saat aplikasi dijalankan. Pastikan direktori tersebut dapat ditulisi. Aplikasi mendukung hingga 100 tugas dengan deskripsi maksimal 80 karakter.
