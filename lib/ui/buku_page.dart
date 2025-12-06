import 'package:flutter/material.dart';
import 'package:tokokita/bloc/logout_bloc.dart';
import 'package:tokokita/bloc/buku_bloc.dart'; // Ganti import bloc
import 'package:tokokita/model/buku.dart';     // Ganti import model
import 'package:tokokita/ui/login_page.dart';
import 'package:tokokita/ui/buku_detail.dart'; // Ganti import detail
import 'package:tokokita/ui/buku_form.dart';   // Ganti import form

class BukuPage extends StatefulWidget {
  const BukuPage({Key? key}) : super(key: key);

  @override
  _BukuPageState createState() => _BukuPageState();
}

class _BukuPageState extends State<BukuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventaris Buku Khaila'), // Sesuai instruksi soal
        backgroundColor: Colors.brown, // Wajib Coklat
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BukuForm()));
              },
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: () async {
                await LogoutBloc.logout().then((value) => {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false)
                    });
              },
            )
          ],
        ),
      ),
      body: FutureBuilder<List<Buku>>(
        future: BukuBloc.getBukus(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListBuku(list: snapshot.data)
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ListBuku extends StatelessWidget {
  final List? list;
  const ListBuku({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list == null ? 0 : list!.length,
        itemBuilder: (context, i) {
          return ItemBuku(buku: list![i]);
        });
  }
}

class ItemBuku extends StatelessWidget {
  final Buku buku;
  const ItemBuku({Key? key, required this.buku}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BukuDetail(buku: buku)));
      },
      child: Card(
        // Sedikit styling biar cantik
        color: Colors.brown[50], 
        margin: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(
            buku.judul!,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
          ),
          subtitle: Text("Penulis: ${buku.penulis} | Harga: Rp. ${buku.harga}"),
          trailing: Text("${buku.jumlah} pcs"),
        ),
      ),
    );
  }
}