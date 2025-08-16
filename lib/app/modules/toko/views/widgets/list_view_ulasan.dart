import 'package:flutter/material.dart';

class ListViewUlasan extends StatelessWidget {
  final List<Map<String, dynamic>> ulasanList;
  const ListViewUlasan({super.key, required this.ulasanList});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: ulasanList.length,
      itemBuilder: (context, index) {
        final ulasan = ulasanList[index];
        return ReviewItem(
          user: ulasan['user'],
          review: ulasan['review'],
          menu: ulasan['menu'],
          date: ulasan['date'],
          rating: ulasan['rating'],
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}

class ReviewItem extends StatelessWidget {
  final String user;
  final String review;
  final String menu;
  final String date;
  final int rating;

  const ReviewItem({
    required this.user,
    required this.review,
    required this.menu,
    required this.date,
    required this.rating,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_circle, size: 32, color: Colors.grey),
              const SizedBox(width: 8),
              Text(user, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Text(date,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                color: index < rating
                    ? const Color(0xFFFFC107)
                    : const Color(0xFFE0E0E0),
                size: 16,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(review),
          const SizedBox(height: 4),
          Text('Menu: $menu',
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}