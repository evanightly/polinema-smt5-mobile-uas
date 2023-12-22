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
- `server` : Direktori untuk aplikasi server (Laravel)

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
8. Jalankan perintah `php artisan sweetalert:publish`
10. Jalankan perintah `php artisan serve`

<!-- /// -->
cd server && npm run dev
cd server && php artisan serve
cd server && php artisan dump-server
cd client && dart run build_runner watch -d
cd client && flutter run

## Hard Note
1. Jika anda akan beralih dari akun user ke akun admin, atau sebaliknya, maka setelah logout anda sebaiknya melakukan close aplikasi/reset aplikasi terlebih dahulu


## Anggota Kelompok

1. [Diva Gracia](https://github.com/diva-gsc)
2. [Galur Arasy L](https://github.com/evanightly)
3. [M. Ariesta](https://github.com/EvosMan)
4. [Rama Wijaya](https://github.com/ramawijaya1)
5. [Selly Amelia](https://github.com/sellyamelia)

## Pembagian Tugas

- Mobile
  - Login (Selly)
  - Admin
    - Admin Management (Arya)
    - User Management (Diva)
    - Car Management
      - Car (Rama)
      - Car fuel (Rama)
      - Car brand (Rama)
      - Car body type (Rama)
    - Transactions (Verify Transactions) (Galur)
    - Settings (Dark mode) (Galur)
    - Profile (Galur)
  - User
    - Register  (Galur)
    - Login  (Galur)
    - Dashboard (Add item to cart) (Galur)
    - Filter/SPK (Galur)
    - Cart (Galur)
    - Checkout (Galur)
    - Transaction Details/History (Galur)
    - Profile (Galur)
    - Settings (Galur)

- Website
  - Login (Selly)
  - Admin
    - Admin Management (Arya)
    - User Management (Diva)
    - Car Management
      - Car (Rama)
      - Car fuel (Rama)
      - Car brand (Rama)
      - Car body type (Rama)
    - Transactions (Verify Transactions) (Galur)
    - Settings (Dark mode) (Galur)
    - Profile (Galur)
    
## Note
1.  Transaction Entity
    <br>
    Transaction per time or per item?
      - Hierarchy:
        - One time transaction
          - Data model: Transaction (user, car)
          - Example: User can only buy one car at a time
        <br>
        <br>
        OR
        <br>
        <br>
        - Per item transaction
          - Transaction (user)
          - Data mode: Detail Transaction (car, transaction)
          - Example: User can buy multiple cars at a time
2.  Transaction process
    1. User choose car
    2. User upload payment proof
    3. Admin verify payment proof (Admin has relation with transaction entity)
    4. Admin send car to user
    5. User receive car
    6. User confirm transaction
    7. Transaction complete
3.  Transaction status
    - Waiting for payment
    - Waiting for verification
    - Waiting for delivery
    - Waiting for confirmation
    - Complete
    - Cancelled
    
## Bugs
- Navbar light mode button not sync properly
- Cart 
    - Quantity field doubled when added then closed - Fixed
    - Null check if qty input empty - Fixed
    - Cart qty event debounce, - Fixed
    - Cart total not synced after changing car qty - Fixed
- Register User
  - User already created, but not redirecting - Fixed
- Update Profile
  - Both users
      - Rerender image when selected - Fixed
      - Update userAuth state provider after user updated their profile - Fixed

## Progress
- Admin
  - login ✔
  - Admin Management
    - Create ✔
    - Read ✔
    - Update ✔
    - Delete ✔
  - User Management
    - Create ✔
    - Read ✔
    - Update ✔
    - Delete ✔
  - Car Inventory
    - Create ✔
    - Read ✔ 
    - Update ✔
    - Delete ✔
  - Car Fuel
    - Create ✔
    - Read ✔
    - Update ✔
    - Delete ✔
  - Car Brand
    - Create ✔
    - Read ✔
    - Update ✔
    - Delete ✔
  - Car Body Type
    - Create ✔
    - Read ✔
    - Update ✔
    - Delete ✔
  - Transactions
    - Read ✔
      - Verify Transaction Proofs ✔
      - Accept Transaction ✔
    - Delete

- User
  - Register ✔
  - Login ✔
  - Dashboard
    - Home
      - List Barang ✔
      - Filter Barang + SPK ✔
    - Cart ✔
    - Transaction List ✔

- Settings 
  - Dark Mode ✔
- Website Profile
  - Update Profile ✔
- Profile
  - Update Profile ✔
