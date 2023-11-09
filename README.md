# Sistem Informasi Inventory untuk Penjualan Mobil

## Deskripsi

Sistem ini dibuat untuk memenuhi tugas akhir mata kuliah Pemrograman Mobile. Sistem ini dibuat dengan menggunakan bahasa pemrograman Dart dan framework Flutter. Sistem ini dirancang untuk diintegrasikan dengan ERP Odoo. Aplikasi ini bertujuan untuk memudahkan proses penjualan mobil dengan menyediakan sistem informasi inventory yang efisien.

## Fitur

- Manajemen gudang
- Kontrol stok
- Proses transaksi

## Fitur tambahan

- User profile
- Settings
  - Dark mode

## Direktori

- `client` : Direktori untuk aplikasi client (Flutter)
- `server` : Direktori untuk aplikasi server (Belum ditentukan)

## Cara Penggunaan

1. Clone repository ini
2. Masuk pada direktori `client`
3. Jalankan perintah `flutter pub get`
4. Jalankan perintah `flutter run`
5. Jalankan perintah `dart run build_runner watch -d`

<!-- Server Laravel -->
6. Masuk pada direktori `server`
7. Jalankan perintah `composer install`
8. Jalankan perintah `php artisan key:generate`
9. Jalankan perintah `php artisan storage:link`
10. Jalankan perintah `php artisan serve`

## Progress
- Admin
  - Create
  - Read
  - Update
  - Delete
- Inventory
  - Create v
  - Read v 
  - Update
  - Delete v
- Transaksi
  - Create
  - Read
  - Update
  - Delete
- User
  - Create
  - Read v
  - Update
  - Delete
- Settings v
  - Dark Mode v
- Profile
  - Update Profile

## Anggota Kelompok

1. [Diva Gracia](https://github.com/diva-gsc)
2. [Galur Arasy L](https://github.com/evanightly)
3. [M. Ariesta](https://github.com/EvosMan)
4. [Rama Wijaya](https://github.com/ramawijaya1)
5. [Selly Amelia](https://github.com/sellyamelia)

## Pembagian Tugas

- Register + Login + Logout (Selly)

- Dashboard
  - User
    - Filter Barang
    - Transaksi Barang  

  - Admin
    - Admin Management
      - Create (Super Admin) (Ariesta)
      - Read + Delete (Ariesta)
      - Update (Super Admin) (Diva)
  
    - Inventory
      - Create (Rama) : ID, Nama, Jenis, Harga, Tipe
      - Detail Information (Rama)
      - Read + Delete (Galur)
      - Update (Galur)
  
    - Settings
      - DarkMode (Galur)
  
    - Profile
      - Update Profile (Diva)
