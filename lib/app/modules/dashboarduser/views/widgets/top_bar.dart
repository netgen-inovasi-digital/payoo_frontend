import 'package:flutter/material.dart';
import '../../../../components/custom_text_field.dart';

class TopBar extends StatelessWidget {
	const TopBar({super.key});

	@override
	Widget build(BuildContext context) {
			return Row(
				children: [
					const Expanded(
						child: CustomTextField(
							hintText: 'cari nama toko',
							prefixIcon: Icon(Icons.search, color: Colors.grey),
							height: 48,
							width: double.infinity,
						),
					),
					const SizedBox(width: 12),
					Container(
						width: 46,
						height: 46,
						decoration: const BoxDecoration(
							color: Colors.white,
							shape: BoxShape.circle,
						),
						child: IconButton(
							icon: const Icon(Icons.person, color: Colors.grey),
							onPressed: () {},
						),
					),
				],
			);
	}
}
