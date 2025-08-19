// app/modules/data_produk/models/Produk.dart
class Produk {
  final int id; // Assuming each Produk has a unique ID
  final String name;
  final double price;
  final double modalPrice;
  final int stock;
  final String imageUrl;
  final String deskripsi;
  final String category; // Added missing category field

  Produk({
    required this.id,
    required this.name,
    required this.price,
    required this.modalPrice,
    required this.stock,
    required this.imageUrl,
    required this.deskripsi,
    required this.category,
  });
}

//data isian
final List<Produk> ProdukList = [
  Produk(
    id: 1,
    name: 'Classic Burger',
    price: 25000,
    modalPrice: 15000,
    stock: 20,
    imageUrl: 'https://static.vecteezy.com/system/resources/previews/027/145/340/non_2x/delicious-double-size-burger-isolated-on-transparent-background-png.png',
    deskripsi: 'Burger klasik dengan daging sapi, selada, tomat, dan saus spesial. Cita rasa autentik dengan bahan-bahan segar pilihan.',
    category: 'Makanan'
  ),
  Produk(
    id: 2,
    name: 'Beef Mentai',
    price: 25000,
    modalPrice: 16000,
    stock: 20,
    imageUrl: 'https://i.gojekapi.com/darkroom/gofood-indonesia/v2/images/uploads/28a86197-a2fb-44b0-8944-73d683dc2c9b_Go-Biz_20220324_115050.jpeg',
    deskripsi: 'Burger daging sapi dengan saus mentai yang creamy dan gurih. Paduan sempurna rasa Jepang dan Western.',
    category: 'Makanan'
  ),
  Produk(
    id: 3,
    name: 'Cheeseburger Universal (Double)',
    price: 28000,
    modalPrice: 18000,
    stock: 20,
    imageUrl: 'https://static.vecteezy.com/system/resources/previews/027/143/844/non_2x/delicious-cheese-burger-on-transparent-background-png.png',
    deskripsi: 'Double cheeseburger dengan keju leleh yang melimpah. Daging sapi double dengan rasa yang tak terlupakan.',
    category: 'Makanan'
  ),
  Produk(
    id: 4,
    name: 'Chicken Burger',
    price: 20000,
    modalPrice: 12000,
    stock: 20,
    imageUrl: 'https://static.vecteezy.com/system/resources/thumbnails/032/325/117/small_2x/fried-chicken-burger-isolated-on-transparent-background-file-cut-out-ai-generated-png.png',
    deskripsi: 'Burger ayam crispy dengan tekstur renyah di luar dan juicy di dalam. Disajikan dengan sayuran segar.',
    category: 'Makanan'
  ),
  Produk(
    id: 5,
    name: 'Chicken Mentai',
    price: 20000,
    modalPrice: 13000,
    stock: 20,
    imageUrl: 'https://static.vecteezy.com/system/resources/thumbnails/054/398/311/small/truffle-chicken-mentai-sauce-with-egg-png.png',
    deskripsi: 'Burger ayam dengan saus mentai yang creamy. Kombinasi unik antara ayam crispy dan saus khas Jepang.',
    category: 'Makanan'
  ),
  Produk(
    id: 6, // Changed from 5 to 6 to avoid duplicate ID
    name: 'Es Susu Gula Aren',
    price: 12000,
    modalPrice: 7000,
    stock: 20,
    imageUrl: 'https://waroengsteakandshake.com/img/img_menu/Caramel_Latte_Ice1.png',
    deskripsi: 'Minuman segar es susu dengan gula aren alami. Manis alami dengan cita rasa tradisional Indonesia.',
    category: 'Minuman'
  ),
];
