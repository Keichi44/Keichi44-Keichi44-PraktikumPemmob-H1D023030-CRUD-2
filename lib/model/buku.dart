class Buku {
  String? id;
  String? judul;
  int? harga;
  int? jumlah;
  String? tanggalMasuk;
  int? volume;
  String? penulis;
  String? penerbit;

  Buku({
    this.id,
    this.judul,
    this.harga,
    this.jumlah,
    this.tanggalMasuk,
    this.volume,
    this.penulis,
    this.penerbit
  });

  factory Buku.fromJson(Map<String, dynamic> obj) {
    return Buku(
      id: obj['id'].toString(),
      judul: obj['judul'],
      harga: int.parse(obj['harga'].toString()),
      jumlah: int.parse(obj['jumlah'].toString()),
      tanggalMasuk: obj['tanggal_masuk'],
      volume: int.parse(obj['volume'].toString()),
      penulis: obj['penulis'],
      penerbit: obj['penerbit'],
    );
  }
}