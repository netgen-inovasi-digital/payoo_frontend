import 'package:flutter/material.dart';
import 'package:payoo/app/data/models/stok_model.dart';
import 'package:payoo/config/utils/constant.dart';
import '../stok_detail_view.dart';
import 'package:get/get.dart';

class ListViewStok extends StatelessWidget {
	final List<ProductWithStock> stokList;

	const ListViewStok({
		super.key,
		required this.stokList,
	});



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
													item.name,
													style: const TextStyle(
														fontWeight: FontWeight.bold,
														fontSize: 18,
													),
												),
												Text(
													formatRupiah(item.sellingPrice),
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
													formatRupiah(item.costPrice),
													style: const TextStyle(
														color: Colors.grey,
														fontSize: 13,
													),
												),
												Text(
													'Stok = ${item.stock} ${item.unit ?? 'pcs'}',
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
