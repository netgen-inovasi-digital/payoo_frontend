import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
	const BottomNavBar({super.key});

	@override
	Widget build(BuildContext context) {
		return Container(
			height: 80,
			decoration: const BoxDecoration(
				color: Colors.green,
				borderRadius: BorderRadius.only(
					topLeft: Radius.circular(20),
					topRight: Radius.circular(20),
				),
			),
			child: Row(
				mainAxisAlignment: MainAxisAlignment.spaceAround,
				children: [
					_buildNavItem(Icons.apps, 'Semua'),
					_buildNavItem(Icons.favorite_border, 'Favorit'),
					const SizedBox(width: 40), // Space for Cart Button
					_buildNavItem(Icons.local_offer, 'Diskon'),
					_buildNavItem(Icons.campaign, 'Promo'),
				],
			),
		);
	}

	Widget _buildNavItem(IconData icon, String label) {
		return Column(
			mainAxisAlignment: MainAxisAlignment.center,
			children: [
				Icon(icon, color: Colors.white, size: 24),
				const SizedBox(height: 4),
				Text(
					label,
					style: const TextStyle(
						color: Colors.white,
						fontSize: 12,
					),
				),
			],
		);
	}
}
