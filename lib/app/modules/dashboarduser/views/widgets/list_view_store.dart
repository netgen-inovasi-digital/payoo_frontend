import 'package:flutter/material.dart';

class ListViewStore extends StatelessWidget {
  final List<Map<String, dynamic>> tokoList;
  const ListViewStore({super.key, required this.tokoList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: tokoList.length,
      itemBuilder: (context, index) {
        final toko = tokoList[index];
        return Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.5),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: StoreListItem(toko: toko),
              ),
            ),
            // Tambahkan jarak antar item, misal 3px
          ],
        );
      },
    );
  }
}

class StoreListItem extends StatelessWidget {
  final Map<String, dynamic> toko;
  const StoreListItem({super.key, required this.toko});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StoreImage(toko: toko),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                toko['nama']?.toString() ?? '-',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${toko['rating'] ?? '-'}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Text(
                    toko['kategori']?.toString() ?? '-',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Text(
          toko['jarak']?.toString() ?? '-',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class StoreImage extends StatelessWidget {
  final Map<String, dynamic> toko;
  const StoreImage({super.key, required this.toko});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: toko['image'] != null && toko['image'].toString().isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                toko['image'].toString(),
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    FallbackImage(toko: toko),
              ),
            )
          : FallbackImage(toko: toko),
    );
  }
}

class FallbackImage extends StatelessWidget {
  final Map<String, dynamic> toko;
  const FallbackImage({super.key, required this.toko});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          (toko['nama']?.toString().isNotEmpty ?? false)
              ? toko['nama'].toString().substring(0, 1).toUpperCase()
              : '?',
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
