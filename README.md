# Laporan Tugas 9 - Pertemuan 11 (CRUD Mobile Full Stack)

**Nama:** Khaila Salsa Marfah Bilqis  
**NIM:** H1D023030  
**Shift:** H / Shift C  
**Mata Kuliah:** Praktikum Pemrograman Mobile  
**Tech Stack:** Flutter (Frontend) & CodeIgniter 4 (Backend)

---

## 📝 Deskripsi Proyek
Aplikasi **TokoKita** ini merupakan implementasi *Full Stack Mobile Application* yang menghubungkan frontend **Flutter** dengan backend **CodeIgniter 4 (REST API)**. Aplikasi ini telah memiliki fitur lengkap mulai dari Autentikasi Pengguna (Registrasi & Login), Manajemen Data Produk (CRUD - Create, Read, Update, Delete), hingga manajemen sesi pengguna (Logout).

---

## 🚀 Dokumentasi Alur Proses & Implementasi Kode

Berikut adalah penjelasan detail langkah demi langkah untuk setiap proses utama dalam aplikasi.

### 1. Proses Registrasi User
Fitur ini digunakan untuk mendaftarkan akun baru ke sistem database.

**Langkah a: Mengisi Form Registrasi**
Pengguna menginputkan Nama, Email, Password, dan Konfirmasi Password. Sistem melakukan validasi input (Email harus valid, Password minimal 6 karakter).

![Screenshot Form Registrasi](screenshots_app/registrasi_form.png)
*(Form registrasi diisi oleh pengguna)*

**Langkah b: Eksekusi & Respon Sukses**
Ketika tombol "Registrasi" ditekan, aplikasi memanggil `RegistrasiBloc` untuk mengirim data ke API. Jika sukses, muncul dialog konfirmasi.

![Screenshot Registrasi Sukses](screenshots_app/registrasi_sukses.png)
*(Popup berhasil registrasi)*

**💻 Penjelasan Kode:**
Pada `ui/registrasi_page.dart`, fungsi `_submit` memanggil Bloc untuk mengirim request POST:
```dart
RegistrasiBloc.registrasi(
    nama: _namaTextboxController.text,
    email: _emailTextboxController.text,
    password: _passwordTextboxController.text)
.then((value) {
    // Tampilkan SuccessDialog jika berhasil
    showDialog(...);
}, onError: (error) {
    // Tampilkan WarningDialog jika gagal
    showDialog(...);
});

### 2. Proses Login User
Fitur untuk masuk ke aplikasi dan mendapatkan Token akses.

**Langkah a: Mengisi Kredensial**
Pengguna memasukkan Email dan Password yang sudah terdaftar.

![Screenshot Form Login](screenshots_app/login_form.png)
*(Tampilan halaman login)*

**Langkah b: Validasi & Penyimpanan Token**
Jika login berhasil (Status Code 200), aplikasi akan menyimpan `token` dan `userID` ke penyimpanan lokal (`SharedPreferences`) agar user tidak perlu login ulang saat aplikasi dibuka kembali.

![Screenshot Login Sukses](screenshots_app/list_produk.png)
*(Pengguna diarahkan ke halaman List Produk)*

**💻 Penjelasan Kode:**
Pada `ui/login_page.dart`, token disimpan jika API merespon sukses:
```dart
LoginBloc.login(
    email: _emailTextboxController.text,
    password: _passwordTextboxController.text)
.then((value) async {
  if (value.code == 200) {
    // Simpan Token & UserID ke Memory HP
    await UserInfo().setToken(value.token.toString());
    await UserInfo().setUserID(int.parse(value.userID.toString()));
    
    // Pindah ke Dashboard (ProdukPage)
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const ProdukPage()));
  }
});

### 3. Proses Menampilkan Data (Read)
Menampilkan daftar produk yang diambil langsung dari database server.

**Langkah a: Fetching Data API**
Saat halaman dibuka, aplikasi menggunakan `FutureBuilder` untuk mengambil data JSON dari API dan menampilkannya dalam bentuk List.

![Screenshot List Produk](screenshots_app/list_produk.png)
*(Daftar produk berhasil dimuat)*

**Langkah b: Detail Produk**
Ketika salah satu item diklik, aplikasi menavigasi ke halaman Detail untuk menampilkan info lengkap produk tersebut.

![Screenshot Detail Produk](screenshots_app/detail_produk.png)
*(Halaman detail menampilkan Kode, Nama, dan Harga)*

**💻 Penjelasan Kode:**
[cite_start]Pada `ui/produk_page.dart`, widget `FutureBuilder` menunggu data dari `ProdukBloc` [cite: 3263-3275]:
```dart
body: FutureBuilder<List>(
  future: ProdukBloc.getProduks(), // Request GET ke API
  builder: (context, snapshot) {
    if (snapshot.hasError) print(snapshot.error);
    return snapshot.hasData
        ? ListProduk(list: snapshot.data) // Tampilkan data jika ada
        : const Center(child: CircularProgressIndicator()); // Loading jika belum ada
  },
),

### 4. Proses Tambah Data Produk (Create)
Menambahkan data barang dagangan baru ke database.

**Langkah a: Form Tambah Produk**
Pengguna menekan tombol `(+)` di halaman utama, lalu mengisi form Kode, Nama, dan Harga Produk.

![Screenshot Form Tambah](screenshots_app/tambah_produk.png)
*(Form tambah produk dalam keadaan kosong)*

**Langkah b: Menyimpan Data**
Tombol "SIMPAN" akan memicu fungsi `simpan()` yang mengirim request `POST` ke API.

**💻 Penjelasan Kode:**
[cite_start]Pada `ui/produk_form.dart`, data dikirim melalui Bloc [cite: 1590-1593]:
```dart
ProdukBloc.addProduk(produk: createProduk).then((value) {
    // Jika sukses, kembali ke halaman List Produk
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => const ProdukPage()));
}, onError: (error) {
    showDialog(...); // Tampilkan error jika gagal
});

### 5. Proses Ubah Data Produk (Update)
Mengedit informasi produk yang sudah ada di database.

**Langkah a: Form Edit (Pre-filled)**
Di halaman Detail, klik tombol **EDIT**. Form akan terbuka dengan data produk lama yang otomatis terisi (*Pre-filled*). Judul form berubah menjadi "UBAH PRODUK".

![Screenshot Form Edit](screenshots_app/edit_produk.png)
*(Form edit dengan data yang sudah terisi otomatis)*

**Langkah b: Menyimpan Perubahan**
Tombol "UBAH" akan memicu fungsi `ubah()` yang mengirim request `PUT` ke API untuk memperbarui data.

**💻 Penjelasan Kode:**
[cite_start]Pada `ui/produk_form.dart`, fungsi `ubah()` memanggil Bloc untuk update data [cite: 3486-3497]:
```dart
void ubah() {
  // Ambil ID produk yang sedang diedit
  Produk updateProduk = Produk(id: widget.produk!.id!);
  
  // Ambil data baru dari text controller
  updateProduk.kodeProduk = _kodeProdukTextboxController.text;
  updateProduk.namaProduk = _namaProdukTextboxController.text;
  updateProduk.hargaProduk = int.parse(_hargaProdukTextboxController.text);

  // Kirim ke API melalui Bloc
  ProdukBloc.updateProduk(produk: updateProduk).then((value) {
    // Kembali ke list produk jika sukses
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => const ProdukPage()));
  }, onError: (error) {
    showDialog(...); // Tampilkan error
  });
}

### 6. Proses Hapus Data Produk (Delete)
Menghapus produk dari database secara permanen.

**Langkah a: Konfirmasi Penghapusan**
Klik tombol **DELETE** di halaman Detail. Dialog konfirmasi akan muncul untuk mencegah ketidaksengajaan penghapusan data.

![Screenshot Dialog Hapus](screenshots_app/dialog_hapus.png)
*(Dialog konfirmasi hapus)*

**Langkah b: Eksekusi Hapus**
Jika pengguna memilih "Ya", aplikasi akan mengirim request `DELETE` ke API berdasarkan ID produk yang dipilih.

**💻 Penjelasan Kode:**
[cite_start]Pada `ui/produk_detail.dart`, fungsi `confirmHapus()` menangani logika dialog dan pemanggilan Bloc [cite: 3703-3733]:
```dart
void confirmHapus() {
  AlertDialog alertDialog = AlertDialog(
    content: const Text("Yakin ingin menghapus data ini?"),
    actions: [
      OutlinedButton(
        child: const Text("Ya"),
        onPressed: () {
          // Panggil Bloc untuk hapus data
          ProdukBloc.deleteProduk(id: int.parse(widget.produk!.id!)).then(
              (value) => {
                    // Jika berhasil, kembali ke halaman List Produk
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ProdukPage()))
                  }, onError: (error) {
                    showDialog(...); // Tampilkan error
                  });
        },
      ),
      OutlinedButton(
        child: const Text("Batal"),
        onPressed: () => Navigator.pop(context),
      )
    ],
  );
  showDialog(builder: (context) => alertDialog, context: context);
}

### 7. Proses Logout
Keluar dari aplikasi dan menghapus sesi pengguna agar akun tidak dapat diakses tanpa login ulang.

**Langkah a: Menu Logout**
Tombol logout terdapat pada Sidebar Drawer di halaman List Produk. Pengguna membuka drawer dengan menggeser layar dari kiri ke kanan atau menekan ikon menu hamburger.

![Screenshot Logout](screenshots_app/drawer_logout.png)
*(Tampilan drawer dengan tombol logout)*

**Langkah b: Penghapusan Sesi**
Saat tombol "Logout" ditekan, aplikasi akan menjalankan fungsi untuk menghapus Token dan UserID dari memori lokal (`SharedPreferences`), lalu mengarahkan pengguna kembali ke halaman Login.

**💻 Penjelasan Kode:**
[cite_start]Fungsi logout terdapat pada file `lib/helpers/user_info.dart` yang bertugas membersihkan data sesi [cite: 74-76]:
```dart
Future logout() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear(); // Menghapus semua data sesi (Token & User ID)
}