# 🍽️ Recipe-App Flutter

**Recipe-App** adalah aplikasi pencarian dan manajemen resep masakan berbasis **Flutter**, dengan UI modern, integrasi API real-time, serta fitur interaktif seperti **chat AI**, **trending recipes**, dan **CRUD Resepku**.

Aplikasi ini memudahkan pengguna untuk:
- Menemukan resep dari berbagai negara.
- Melihat detail lengkap: bahan, langkah, nutrisi, badge halal, porsi, dan waktu memasak.
- Membuat resep sendiri (create, edit, delete).
- Menggunakan fitur percakapan AI untuk rekomendasi resep.
- Mengecek status **Halal** otomatis pada setiap bahan.

---

## ✨ Fitur Utama

### 🔍 Pencarian & Filter Resep
- Cari resep secara real-time menggunakan API.
- Filter berdasarkan kata kunci.
- Menampilkan status **Halal**.

### 🔥 Trending Recipes
- Mengambil resep populer langsung dari API.
- Menampilkan waktu masak, rating, dan negara asal.

### 📝 Resepku (CRUD Lokal)
- Tambah resep buatan pengguna.
- Edit & delete resep.
- Tampilan detail versi lokal dengan bahan, langkah, nutrisi.

### 🤖 Chat AI
- Tanya AI seperti:
  - "Resep Ayam Pedas"
  - "Resep Burger"
- Mendapatkan hasil yang langsung diambil dari API.

### 🧼 Pengecekan Halal Otomatis
- Algoritma sederhana memeriksa daftar bahan.
- Badge otomatis Hijau (Halal) / Abu (Tidak Halal).

### 🧭 Navigasi Modern
- Tab bar 4 halaman: Home – Explore – Chat – Profile.
- Setelah:
  - **Create resep → otomatis ke Resepku**
  - **Edit resep → otomatis masuk ke Detail Resep versi terbaru**

---

## 🛠️ Daftar Endpoint API yang Digunakan

Berikut semua endpoint lengkap yang digunakan aplikasi:

| Kategori | Endpoint | Deskripsi |
|---------|----------|-----------|
| **Trending Recipes** | `recipes/complexSearch?sort=popularity&number=10&addRecipeInformation=true` | Mengambil resep populer dengan informasi lengkap |
| **Random Recipes** | `recipes/random?number=6` | Mengambil 6 resep acak untuk rekomendasi |
| **Search/Filter Recipes** | `recipes/complexSearch?query={keyword}&number=20&addRecipeInformation=true&includeNutrition=true` | Mencari resep berdasarkan kata kunci |
| **Example Category: Middle Eastern** | `recipes/complexSearch?query=middle+eastern&number=3&addRecipeInformation=true` | Contoh pencarian kategori tertentu |
| **Recipe Detail** | `recipes/{id}/information?includeNutrition=true` | Mendapatkan detail lengkap resep (bahan, langkah, nutrisi) |
| **Chat AI** | `food/converse?text={message}&contextId={id}` | Chat AI dengan Spoonacular (menghasilkan jawaban + rekomendasi) |

---

## 📦 Cara Instalasi

Ikuti langkah-langkah berikut untuk menjalankan aplikasi:

```sh
git clone https://github.com/adamftnnn-ui/Recipe-App.git
cd Recipe-App
flutter pub get
flutter run
