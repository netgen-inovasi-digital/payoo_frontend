class Constants {
  // ================== BACKEND PAYOO ==================
  // Ganti sesuai environment (dev/staging/prod)
  static const baseUrl = 'https://payoo.netgen.id/api';

  // Auth
  static const AUTH_REGISTER = '/auth/register';
  static const AUTH_LOGIN = '/auth/login';

  // Account
  static const ACCOUNT_PROFILE = '/account/profile';
  static const ACCOUNT_UPDATE_PROFILE = '/account/profile'; // PUT
  static const ACCOUNT_CHANGE_PASSWORD = '/account/change-password';

  // Products
  static const PRODUCTS = '/products';
  static const PRODUCT_BY_ID = '/products/{id}';

  // Categories
  static const CATEGORIES = '/categories';
  static const CATEGORY_BY_ID = '/categories/{id}';

  // Shops
  static const SHOPS = '/shops';
  static const SHOP_BY_ID = '/shops/{id}';

  // Compositions
  static const COMPOSITIONS = '/compositions';
  static const COMPOSITION_BY_ID = '/compositions/{id}';

  // Stocks
  static const STOCKS_CREATE = '/stocks'; // POST
  static const STOCKS_BY_COMPOSITION_ID = '/stocks/{composition_id}';

  // ================== API LAIN (Lokasi) ==================
  static const baseUrllokasi = 'https://alamat.thecloudalert.com/api';
  static const lokasiProvinsiUrl = '$baseUrllokasi/provinsi/get';
  static const lokasiKotaUrl = '$baseUrllokasi/kabkota/get/?d_provinsi_id=';
}
