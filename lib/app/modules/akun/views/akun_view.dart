import 'package:flutter/material.dart';
import 'package:payoo/app/components/custom_app_bar.dart';
import 'package:payoo/app/components/custom_editable_image.dart';
import 'package:payoo/app/modules/akun/views/widgets/form_edit.dart';

class AkunView extends StatefulWidget {
  const AkunView({super.key});

  @override
  State<AkunView> createState() => _AkunViewState();
}

class _AkunViewState extends State<AkunView> {
  bool belumDaftar = true;

  // mengubah state daftar
  void _toggleWidget() {
    setState(() {
      belumDaftar = !belumDaftar; //ubah state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Edit Akun',
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              EditableImage(
                imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png', // URL gambar
                onEdit: () {
                  // Aksi saat tombol edit ditekan
                  print("Edit button tapped");
                },
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FormEdit(onDaftar: _toggleWidget)),
            ],
          ),
        ),
      ),
    );
  }
}
