import 'package:flutter/material.dart';

class KategoriList extends StatelessWidget {
  final List<String> kategoriList;
  final void Function(int) onDelete;

  const KategoriList({
    super.key,
    required this.kategoriList,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: kategoriList.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = kategoriList[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 30),
          title: Text(
            item,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => onDelete(index),
          ),
        );
      },
    );
  }
}
