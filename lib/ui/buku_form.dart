import 'package:flutter/material.dart';
import 'package:tokokita/bloc/buku_bloc.dart';
import 'package:tokokita/model/buku.dart';
import 'package:tokokita/ui/buku_page.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class BukuForm extends StatefulWidget {
  final Buku? buku;
  const BukuForm({Key? key, this.buku}) : super(key: key);

  @override
  _BukuFormState createState() => _BukuFormState();
}

class _BukuFormState extends State<BukuForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH BUKU";
  String tombolSubmit = "SIMPAN";

  // Controller untuk 7 kolom
  final _judulController = TextEditingController();
  final _hargaController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _tanggalMasukController = TextEditingController();
  final _volumeController = TextEditingController();
  final _penulisController = TextEditingController();
  final _penerbitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.buku != null) {
      setState(() {
        judul = "UBAH BUKU";
        tombolSubmit = "UBAH";
        _judulController.text = widget.buku!.judul!;
        _hargaController.text = widget.buku!.harga.toString();
        _jumlahController.text = widget.buku!.jumlah.toString();
        _tanggalMasukController.text = widget.buku!.tanggalMasuk!;
        _volumeController.text = widget.buku!.volume.toString();
        _penulisController.text = widget.buku!.penulis!;
        _penerbitController.text = widget.buku!.penerbit!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField("Judul Buku", _judulController),
                _buildNumberField("Harga", _hargaController),
                _buildNumberField("Jumlah", _jumlahController),
                _buildTextField("Tanggal Masuk", _tanggalMasukController),
                _buildNumberField("Volume", _volumeController),
                _buildTextField("Penulis", _penulisController),
                _buildTextField("Penerbit", _penerbitController),
                const SizedBox(height: 20),
                _buttonSubmit()
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget Helper biar tidak ngetik ulang terus
  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      controller: controller,
      validator: (value) => value!.isEmpty ? "$label harus diisi" : null,
    );
  }

  Widget _buildNumberField(String label, TextEditingController controller) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: TextInputType.number,
      controller: controller,
      validator: (value) => value!.isEmpty ? "$label harus diisi" : null,
    );
  }

  Widget _buttonSubmit() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
      child: Text(tombolSubmit),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate && !_isLoading) {
          if (widget.buku != null) {
            ubah();
          } else {
            simpan();
          }
        }
      },
    );
  }

  simpan() {
    setState(() => _isLoading = true);
    Buku createBuku = Buku(
      id: null,
      judul: _judulController.text,
      harga: int.parse(_hargaController.text),
      jumlah: int.parse(_jumlahController.text),
      tanggalMasuk: _tanggalMasukController.text,
      volume: int.parse(_volumeController.text),
      penulis: _penulisController.text,
      penerbit: _penerbitController.text,
    );

    BukuBloc.addBuku(buku: createBuku).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const BukuPage()));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
                description: "Simpan gagal, silahkan coba lagi",
              ));
    });
    setState(() => _isLoading = false);
  }

  ubah() {
    setState(() => _isLoading = true);
    Buku updateBuku = Buku(
      id: widget.buku!.id!,
      judul: _judulController.text,
      harga: int.parse(_hargaController.text),
      jumlah: int.parse(_jumlahController.text),
      tanggalMasuk: _tanggalMasukController.text,
      volume: int.parse(_volumeController.text),
      penulis: _penulisController.text,
      penerbit: _penerbitController.text,
    );

    BukuBloc.updateBuku(buku: updateBuku).then((value) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const BukuPage()));
    }, onError: (error) {
      showDialog(
          context: context,
          builder: (BuildContext context) => const WarningDialog(
                description: "Ubah data gagal, silahkan coba lagi",
              ));
    });
    setState(() => _isLoading = false);
  }
}