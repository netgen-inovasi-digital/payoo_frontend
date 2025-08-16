import 'package:flutter/material.dart';

class ListViewKategori extends StatelessWidget {
	final List<String> kategoriList;
	final void Function(int) onDelete;

	const ListViewKategori({
		super.key,
		required this.kategoriList,
		required this.onDelete,
	});

	@override
	Widget build(BuildContext context) {
		return ListView.builder(
			itemCount: kategoriList.length,
			itemBuilder: (context, index) {
				final item = kategoriList[index];
				return Container(
					width: double.infinity,
					decoration: const BoxDecoration(
						border: Border(
							bottom: BorderSide(color: Colors.grey, width: 0.5),
						),
					),
					child: ListTile(
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
					),
				);
			},
		);
	}
}
