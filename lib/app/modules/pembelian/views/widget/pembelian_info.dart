import 'package:flutter/material.dart';
import 'package:payoo/app/data/models/stok_model.dart';
import 'package:payoo/config/utils/constant.dart';

class PembelianInfo extends StatelessWidget {
  final Stock stok;
  
  const PembelianInfo({super.key, required this.stok});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name with Badge
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
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
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.green.shade200,
                  width: 1,
                ),
              ),
              child: Text(
                "Pembelian",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.green.shade700,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        Divider(color: Colors.grey.shade200, height: 1),
        
        const SizedBox(height: 20),
        
        // Buy Price
        _buildInfoRow(
          label: 'Harga Beli',
          value: formatRupiah(stok.buyPrice),
        ),
        
        const SizedBox(height: 16),
        
        // Quantity
        _buildInfoRow(
          label: 'Jumlah Pembelian',
          value: '${stok.quantity}',
        ),
        
        const SizedBox(height: 16),
        
        // Total Price
        if (stok.buyPrice != null && stok.quantity != null) ...[
          _buildInfoRow(
            label: 'Total Harga',
            value: formatRupiah((stok.buyPrice ?? 0) * (stok.quantity ?? 0)),
            isHighlighted: true,
          ),
          const SizedBox(height: 16),
        ],
        
        // Notes
        _buildInfoRow(
          label: 'Catatan',
          value: stok.notes ?? '-',
        ),
        
        const SizedBox(height: 16),
        
        // Date
        _buildInfoRow(
          label: 'Tanggal Pembelian',
          value: stok.date != null 
              ? "${stok.date!.toLocal().day.toString().padLeft(2, '0')}/${stok.date!.toLocal().month.toString().padLeft(2, '0')}/${stok.date!.toLocal().year}, ${stok.date!.toLocal().hour.toString().padLeft(2, '0')}.${stok.date!.toLocal().minute.toString().padLeft(2, '0')}"
              : '-',
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    bool isHighlighted = false,
  }) {
    return Container(
      padding: isHighlighted ? const EdgeInsets.all(12) : null,
      decoration: isHighlighted
          ? BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.green.shade200,
                width: 1,
              ),
            )
          : null,
      child: Row(
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
                  style: TextStyle(
                    fontSize: isHighlighted ? 16 : 15,
                    fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}