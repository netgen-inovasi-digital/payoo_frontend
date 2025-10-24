import 'package:flutter/material.dart';
import 'package:payoo/app/data/models/stok_model.dart';
import 'package:payoo/config/utils/constant.dart';

class StokInfo extends StatelessWidget {
  final Stock stok;
  
  const StokInfo({super.key, required this.stok});

  @override
  Widget build(BuildContext context) {
    final isStockIn = stok.type == "in";
    
    return Container(
  
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name with Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nama ${stok.productType == 'composition' ? 'Komposisi' : 'Produk'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stok.productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isStockIn ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isStockIn ? Colors.green.shade200 : Colors.red.shade200,
                    width: 1,
                  ),
                ),
                child: Text(
                  isStockIn ? "Masuk" : "Keluar",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: isStockIn ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          Divider(color: Colors.grey.shade200, height: 1),
          
          const SizedBox(height: 20),
          
          // Buy Price (if stock in)
          if (isStockIn) ...[
            _buildInfoRow(
              label: 'Harga Beli',
              value: formatRupiah(stok.buyPrice),
            ),
            const SizedBox(height: 16),
          ],
          
          // Quantity
          _buildInfoRow(
            label: 'Jumlah',
            value: '${stok.quantity}',
          ),
          
          const SizedBox(height: 16),
          
          // Notes
          _buildInfoRow(
            label: 'Catatan',
            value: stok.notes ?? '-',
          ),
          
          const SizedBox(height: 16),
          
          // Date
          _buildInfoRow(
            label: 'Tanggal',
            value: stok.date?.toLocal().toIso8601String().split('T').first ?? '-',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 