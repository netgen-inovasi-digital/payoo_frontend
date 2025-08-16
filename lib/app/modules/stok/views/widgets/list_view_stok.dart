import 'package:flutter/material.dart';
import '../stok_detail_view.dart';
import 'package:get/get.dart';

class ListViewStok extends StatelessWidget {
	final List<Map<String, dynamic>> stokList;

	const ListViewStok({
		super.key,
		required this.stokList,
	});

	String formatRupiah(int value) {
		return 'Rp.${value.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")},-';
	}

	@override
	Widget build(BuildContext context) {
			return ListView.builder(
				itemCount: stokList.length,
				itemBuilder: (context, index) {
					final item = stokList[index];
					return GestureDetector(
						onTap: () {
							Get.to(() => StokDetailView(stok: item));
						},
						child: Container(
							width: double.infinity,
							decoration: const BoxDecoration(
								border: Border(
									bottom: BorderSide(color: Colors.grey, width: 0.5),
								),
							),
							child: Padding(
								padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Row(
											mainAxisAlignment: MainAxisAlignment.spaceBetween,
											children: [
												Text(
													item['nama'],
													style: const TextStyle(
														fontWeight: FontWeight.bold,
														fontSize: 18,
													),
												),
												Text(
													formatRupiah(item['harga']),
													style: const TextStyle(
														fontWeight: FontWeight.bold,
														fontSize: 15,
													),
												),
											],
										),
										const SizedBox(height: 8),
										Row(
											mainAxisAlignment: MainAxisAlignment.spaceBetween,
											children: [
												Text(
													formatRupiah(item['hargaModal']),
													style: const TextStyle(
														color: Colors.grey,
														fontSize: 13,
													),
												),
												Text(
													'Stok = ${item['stok']} pcs',
													style: const TextStyle(
														color: Colors.grey,
														fontSize: 13,
													),
												),
											],
										),
									],
								),
							),
						),
					);
				},
			);
	}
}
