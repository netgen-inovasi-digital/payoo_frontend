// Export currency formatter for global access
export 'currency_formatter.dart';

class Constants {
  // ================== BACKEND PAYOO ==================
  // Ganti sesuai environment (dev/staging/prod)
  static const baseUrl = 'https://payoo.netgen.id/api';

  // Auth
  static const AUTH_REGISTER = '/auth/register';
  static const AUTH_LOGIN = '/auth/login';
  static const ACCOUNT_FORGOT_PASSWORD = '/auth/forgot-password';
  static const ACCOUNT_FORGOT_PASSWORD_VERIFY = '/auth/forgot-password/verify-otp';
  static const ACCOUNT_RESET_PASSWORD = '/auth/reset-password';

  // Account
  static const ACCOUNT_PROFILE = '/account/profile';
  static const ACCOUNT_UPDATE_PROFILE = '/account/profile'; // PUT
  static const ACCOUNT_CHANGE_PASSWORD = '/account/change-password';
  // Products
  static const PRODUCTS = '/products';
  static const PRODUCT_BY_ID = '/products/{id}';
  static const PRODUCT_COMPOSITION = '/products/{id}/compositions';

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
  static const STOCKS= '/stocks'; // POST
  static const STOCKS_BY_COMPOSITION_ID = '/stocks/{composition_id}';
  static const STOCKS_PRODUCTS_SHOP = '/stocks/products/shop'; // GET - New endpoint

  // Orders
  static const ORDER_USER = '/orders/user/{user_id}'; 
  static const ORDER_SHOP = '/orders/shop/{shop_id}';
  static const ORDER_BY_ID = '/orders/{id}';
  static const ORDER_STATUS = '/orders/status/{id}'; //put
  static const ORDERS = '/orders'; //post
  static const DASHBOARD = '/dashboard';
  //reports
  static const REPORTS_SUMMARY = "/reports/{shop_id}/summary";
  static const REPORTS_ORDERS = "/reports/{shop_id}/orders";
  //upload
  static const UPLOAD = '/upload';

  // ================== API LAIN (Lokasi) ==================
  static const baseUrllokasi = 'https://alamat.thecloudalert.com/api';
  static const lokasiProvinsiUrl = '$baseUrllokasi/provinsi/get';
  static const lokasiKotaUrl = '$baseUrllokasi/kabkota/get/?d_provinsi_id=';
}
