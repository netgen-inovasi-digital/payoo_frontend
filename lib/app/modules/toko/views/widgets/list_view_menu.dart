import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/app/modules/toko/views/menu_detail_view.dart';

class MenuListItem extends StatefulWidget {
	final Map<String, dynamic> menu;
	const MenuListItem({super.key, required this.menu});

	@override
	State<MenuListItem> createState() => _MenuListItemState();
}

class _MenuListItemState extends State<MenuListItem> {
	int quantity = 0;

		@override
		Widget build(BuildContext context) {
			return InkWell(
				onTap: () {
					Get.to(() => const MenuDetailView());
				},
				child: Container(
					decoration: const BoxDecoration(
						border: Border(
							bottom: BorderSide(color: Colors.grey, width: 0.5),
						),
					),
					padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
					child: Row(
						children: [
							// Gambar menu
							Container(
								width: 60,
								height: 60,
								decoration: BoxDecoration(
									borderRadius: BorderRadius.circular(8),
									image: DecorationImage(
										image: AssetImage(widget.menu['image']),
										fit: BoxFit.cover,
									),
								),
							),
							const SizedBox(width: 12),
							// Info menu
							Expanded(
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											widget.menu['nama'],
											style: const TextStyle(
												fontWeight: FontWeight.bold,
												fontSize: 16,
											),
										),
										const SizedBox(height: 4),
										Text(
											'Rp.${widget.menu['harga']}',
											style: const TextStyle(
												color: Colors.grey,
												fontSize: 14,
											),
										),
									],
								),
							),
							// Quantity controls
							Row(
								children: [
									// Tombol minus
									InkWell(
										onTap: () {
											if (quantity > 0) {
												setState(() {
													quantity--;
												});
											}
										},
										child: Container(
											width: 32,
											height: 32,
											decoration: BoxDecoration(
												border: Border.all(color: Colors.red),
												shape: BoxShape.circle,
											),
											child: const Icon(
												Icons.remove,
												color: Colors.red,
												size: 16,
											),
										),
									),
									const SizedBox(width: 12),
									// Quantity
									Text(
										'$quantity',
										style: const TextStyle(
											fontWeight: FontWeight.bold,
											fontSize: 16,
										),
									),
									const SizedBox(width: 12),
									// Tombol plus
									InkWell(
										onTap: () {
											setState(() {
												quantity++;
											});
										},
										child: Container(
											width: 32,
											height: 32,
											decoration: BoxDecoration(
												border: Border.all(color: Colors.green),
												shape: BoxShape.circle,
											),
											child: const Icon(
												Icons.add,
												color: Colors.green,
												size: 16,
											),
										),
									),
								],
							),
						],
					),
				),
			);
		}
}
