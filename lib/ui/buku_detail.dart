import 'package:flutter/material.dart';
import 'package:tokokita/bloc/buku_bloc.dart';
import 'package:tokokita/model/buku.dart';
import 'package:tokokita/ui/buku_form.dart';
import 'package:tokokita/ui/buku_page.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class BukuDetail extends StatefulWidget {
  final Buku? buku;
  const BukuDetail({Key? key, this.buku}) : super(key: key);

  @override
  _BukuDetailState createState() => _BukuDetailState();
}

class _BukuDetailState extends State<BukuDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Inventaris Khaila'),
        backgroundColor: Colors.brown,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Judul: ${widget.buku!.judul}", style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("Penulis: ${widget.buku!.penulis}", style: const TextStyle(fontSize: 18.0)),
              Text("Penerbit: ${widget.buku!.penerbit}", style: const TextStyle(fontSize: 18.0)),
              Text("Harga: Rp. ${widget.buku!.harga}", style: const TextStyle(fontSize: 18.0)),
              Text("Jumlah: ${widget.buku!.jumlah}", style: const TextStyle(fontSize: 18.0)),
              Text("Volume: ${widget.buku!.volume}", style: const TextStyle(fontSize: 18.0)),
              Text("Tgl Masuk: ${widget.buku!.tanggalMasuk}", style: const TextStyle(fontSize: 18.0)),
              const SizedBox(height: 20),
              _tombolHapusEdit()
            ],
          ),
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          child: const Text("EDIT", style: TextStyle(color: Colors.brown)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BukuForm(buku: widget.buku!),
              ),
            );
          },
        ),
        const SizedBox(width: 10),
        OutlinedButton(
          child: const Text("DELETE", style: TextStyle(color: Colors.red)),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data buku ini?"),
      actions: [
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () {
            BukuBloc.deleteBuku(id: int.parse(widget.buku!.id!)).then(
                (value) => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const BukuPage()))
                    }, onError: (error) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => const WarningDialog(
                        description: "Hapus gagal, silahkan coba lagi",
                      ));
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
}