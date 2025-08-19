// app/modules/komposisi/model/komposisi_model.dart
class Komposisi {
  final int id;
  final String namaKomposisi;
  final double hargaModal;
  final double hargaJual;
  final int stokKomposisi;
  final String satuan;
  int quantity;

  Komposisi({
    required this.id,
    required this.namaKomposisi,
    required this.hargaModal,
    required this.hargaJual,
    required this.stokKomposisi,
    required this.satuan,
    required this.quantity,
  });
}

// Data dummy komposisi
final List<Komposisi> komposisiList = [
  Komposisi(
    id: 1,
    namaKomposisi: 'Roti',
    hargaModal: 2500,
    hargaJual: 3000,
    stokKomposisi: 15,
    satuan: 'pcs',
    quantity: 2,
  ),
  Komposisi(
    id: 2,
    namaKomposisi: 'Daging Sapi',
    hargaModal: 15000,
    hargaJual: 18000,
    stokKomposisi: 25,
    satuan: 'pcs',
    quantity: 3,
  ),
  Komposisi(
    id: 3,
    namaKomposisi: 'Keju',
    hargaModal: 3000,
    hargaJual: 4000,
    stokKomposisi: 30,
    satuan: 'lembar',
    quantity: 0,
  ),
  Komposisi(
    id: 4,
    namaKomposisi: 'Selada',
    hargaModal: 500,
    hargaJual: 800,
    stokKomposisi: 50,
    satuan: 'lembar',
    quantity: 0,
  ),
  Komposisi(
    id: 5,
    namaKomposisi: 'Tomat',
    hargaModal: 1000,
    hargaJual: 1500,
    stokKomposisi: 40,
    satuan: 'slice',
    quantity: 0,
  ),
  Komposisi(
    id: 6,
    namaKomposisi: 'Saus Mentai',
    hargaModal: 2000,
    hargaJual: 3000,
    stokKomposisi: 20,
    satuan: 'sendok',
    quantity: 0,
  ),
  Komposisi(
    id: 7,
    namaKomposisi: 'Daging Ayam',
    hargaModal: 8000,
    hargaJual: 10000,
    stokKomposisi: 35,
    satuan: 'pcs',
    quantity: 0,
  ),
  Komposisi(
    id: 8,
    namaKomposisi: 'Susu',
    hargaModal: 5000,
    hargaJual: 7000,
    stokKomposisi: 25,
    satuan: 'ml',
    quantity: 0,
  ),
  Komposisi(
    id: 9,
    namaKomposisi: 'Gula Aren',
    hargaModal: 3000,
    hargaJual: 4000,
    stokKomposisi: 15,
    satuan: 'sendok',
    quantity: 0,
  ),
  Komposisi(
    id: 10,
    namaKomposisi: 'Es Batu',
    hargaModal: 500,
    hargaJual: 1000,
    stokKomposisi: 100,
    satuan: 'pcs',
    quantity: 0,
  ),
];
