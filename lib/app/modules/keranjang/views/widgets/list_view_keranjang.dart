import 'package:flutter/material.dart';

class ListViewKeranjang extends StatelessWidget {
  final List<Map<String, dynamic>> pesananList;
  final void Function(int) onEdit;
  final void Function(int) onDelete;

  const ListViewKeranjang({
    super.key,
    required this.pesananList,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pesananList.length,
      itemBuilder: (context, index) {
        final pesanan = pesananList[index];
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey, width: 0.5),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar produk
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: pesanan['active'] == true
                        ? Colors.red
                        : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                // Gambar produk bisa ditambahkan di sini
              ),
              const SizedBox(width: 15),
              // Info produk
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pesanan['nama'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${pesanan['jumlah']} x Rp.${pesanan['harga']} = Rp.${pesanan['total']}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 28,
                      child: OutlinedButton(
                        onPressed: () => onEdit(index),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Edit',
                            style:
                                TextStyle(fontSize: 14, color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
              // Jumlah
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      pesanan['jumlah'].toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // IconButton(
                  // 	icon: const Icon(Icons.more_vert, size: 20),
                  // 	onPressed: () => onDelete(index),
                  // ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
