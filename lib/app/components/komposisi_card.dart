

import 'package:flutter/material.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';

class KomposisiCard extends StatefulWidget {
  final Komposisi komposisi;
  final VoidCallback? onTap;
  final Color cardColor;
  final bool useQuantities;
  
  const KomposisiCard({
    super.key,
    required this.komposisi,
    this.onTap,
    this.cardColor = Colors.white,
    this.useQuantities = false,
  });

  @override
  State<KomposisiCard> createState() => _KomposisiCardState();
}

class _KomposisiCardState extends State<KomposisiCard> {
  String getFormattedPrice(int quantity, double price) {
    if (quantity == 0 || !widget.useQuantities) {
      return "Rp.${price.toStringAsFixed(0)},-";
    }
    return " $quantity x Rp.${price.toStringAsFixed(0)},-";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(25, 10, 30, 10),
        decoration: BoxDecoration(
          color: widget.cardColor,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[300]!,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.komposisi.namaKomposisi,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ), widget.useQuantities ? _buildInputButton(widget.komposisi) : Flexible(
                        child: Text(
                          "Rp.${widget.komposisi.hargaJual.toStringAsFixed(0)},-",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          widget.useQuantities ? getFormattedPrice(widget.komposisi.quantity, widget.komposisi.hargaJual) : "Rp.${widget.komposisi.hargaModal.toStringAsFixed(0)},-",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        "Stok = ${widget.komposisi.stokKomposisi}pcs",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildInputButton(Komposisi komposisi) {
    return Row(
      children: [
        _buildIconButton(Icons.remove, Colors.red, () {
          setState(() {
            if (komposisi.quantity > 0) komposisi.quantity--;
          });
        }),
        Container(
          width: 40,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: TextField(
            controller: TextEditingController(
              text: komposisi.quantity.toString(),
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            onChanged: (value) {
              final newQuantity = int.tryParse(value) ?? 0;
              setState(() {
                komposisi.quantity = newQuantity;
              });
            },
          ),
        ),
        _buildIconButton(Icons.add, Colors.green, () {
          setState(() {
            komposisi.quantity++;
          });
        }),
      ],
    );
  }

  Widget _buildIconButton(IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: color, size: 14),
        onPressed: onPressed,
      ),
    );
  }
}
