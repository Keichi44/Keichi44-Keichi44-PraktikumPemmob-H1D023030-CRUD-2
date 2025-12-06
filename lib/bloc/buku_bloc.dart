import 'dart:convert';
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/buku.dart';

class BukuBloc {
  static Future<List<Buku>> getBukus() async {
    String apiUrl = ApiUrl.listBuku;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listBuku = (jsonObj as Map<String, dynamic>)['data'];
    List<Buku> bukus = [];
    for (int i = 0; i < listBuku.length; i++) {
      bukus.add(Buku.fromJson(listBuku[i]));
    }
    return bukus;
  }

  static Future addBuku({Buku? buku}) async {
    String apiUrl = ApiUrl.createBuku;
    var body = {
      "judul": buku!.judul,
      "harga": buku.harga.toString(),
      "jumlah": buku.jumlah.toString(),
      "tanggal_masuk": buku.tanggalMasuk,
      "volume": buku.volume.toString(),
      "penulis": buku.penulis,
      "penerbit": buku.penerbit,
    };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future updateBuku({required Buku buku}) async {
    String apiUrl = ApiUrl.updateBuku(int.parse(buku.id!));
    var body = {
      "judul": buku.judul,
      "harga": buku.harga.toString(),
      "jumlah": buku.jumlah.toString(),
      "tanggal_masuk": buku.tanggalMasuk,
      "volume": buku.volume.toString(),
      "penulis": buku.penulis,
      "penerbit": buku.penerbit,
    };
    var response = await Api().put(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future<bool> deleteBuku({int? id}) async {
    String apiUrl = ApiUrl.deleteBuku(id!);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['data'];
  }
}