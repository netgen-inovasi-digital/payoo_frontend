import 'package:get/get.dart';
import 'package:payoo/app/data/models/komposisi_model.dart';
import 'package:payoo/app/modules/akun/bindings/akun_binding.dart';
import 'package:payoo/app/modules/akun/views/akun_view.dart';
import 'package:payoo/app/modules/auth/daftar/bindings/daftar_binding.dart';
import 'package:payoo/app/modules/auth/daftar/views/daftar_view.dart';
import 'package:payoo/app/modules/auth/informasi_toko/bindings/informasi_toko_binding.dart';
import 'package:payoo/app/modules/auth/informasi_toko/views/informasi_toko_view.dart';
import 'package:payoo/app/modules/auth/pemulihan/bindings/pemulihan_binding.dart';
import 'package:payoo/app/modules/auth/pemulihan/views/pemulihan_view.dart';
import 'package:payoo/app/modules/auth/pemulihan_callback/bindings/pemulihan_callback_binding.dart';
import 'package:payoo/app/modules/auth/pemulihan_callback/views/pemulihan_callback_view.dart';
import 'package:payoo/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:payoo/app/modules/auth/login/bindings/login_binding.dart';
import 'package:payoo/app/modules/auth/login/views/login_view.dart';
import 'package:payoo/app/modules/dashboarduser/bindings/dashboard_user_binding.dart';
import 'package:payoo/app/modules/dashboarduser/views/dashboard_user_view.dart';
import 'package:payoo/app/modules/data_produk/bindings/data_produk_binding.dart';
import 'package:payoo/app/modules/data_produk/views/data_produk_view.dart';
import 'package:payoo/app/modules/keranjang/bindings/keranjang_binding.dart';
import 'package:payoo/app/modules/keranjang/views/keranjang_view.dart';
import 'package:payoo/app/modules/komposisi/bindings/komposisi_binding.dart';
import 'package:payoo/app/modules/komposisi/views/komposisi_view.dart';
import 'package:payoo/app/modules/laporan/bindings/laporan_binding.dart';
import 'package:payoo/app/modules/laporan/views/laporan_view.dart';
import 'package:payoo/app/modules/produk/bindings/produk_binding.dart';
import 'package:payoo/app/modules/produk/views/produk_view.dart';
import 'package:payoo/app/modules/splash/bindings/splash_binding.dart';
import 'package:payoo/app/modules/splash/views/splash_view.dart';
import 'package:payoo/app/modules/kategori/bindings/kategori_binding.dart';
import 'package:payoo/app/modules/kategori/views/kategori_view.dart';
import 'package:payoo/app/modules/stok/bindings/stok_binding.dart';
import 'package:payoo/app/modules/stok/views/stok_view.dart';
import 'package:payoo/app/modules/struk/bindings/struk_binding.dart'
    show StrukBinding;
import 'package:payoo/app/modules/struk/views/struk_view.dart';
import 'package:payoo/app/modules/tentang_payoo/bindings/tentang_payoo_binding.dart';
import 'package:payoo/app/modules/tentang_payoo/views/tentang_payoo_view.dart';
import 'package:payoo/app/modules/transaksi/bindings/transaksi_binding.dart';
import 'package:payoo/app/modules/transaksi/views/transaksi_view.dart';

import '../modules/dashboard/views/dashboard_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.DAFTAR,
      page: () => const DaftarView(),
      binding: DaftarBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.PEMULIHAN,
      page: () => const PemulihanView(),
      binding: PemulihanBinding(),
    ),
    GetPage(
      name: _Paths.PEMULIHAN_CALLBACK,
      page: () => const PemulihanCallbackView(),
      binding: PemulihanCallbackBinding(),
    ),
    GetPage(
      name: _Paths.INFORMASI_TOKO,
      page: () => const InformasiTokoView(),
      binding: InformasiTokoBinding(),
    ),
    GetPage(
      name: _Paths.AKUN,
      page: () => const AkunView(),
      binding: AkunBinding(),
    ),
    GetPage(
      name: _Paths.PRODUK,
      page: () => const ProdukView(),
      binding: ProdukBinding(),
    ),
    GetPage(
      name: _Paths.KATEGORI,
      page: () => const KategoriView(),
      binding: KategoriBinding(),
    ),
    GetPage(
      name: _Paths.STOK,
      page: () => const StokView(),
      binding: StokBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD_USER,
      page: () => const DashboardUserView(),
      binding: DashboardUserBinding(),
    ),
    GetPage(
      name: _Paths.KOMPOSISI,
      page: () => const KomposisiView(),
      binding: KomposisiBinding(),
    ),
    GetPage(
      name: _Paths.DATA_PRODUK,
      page: () => const DataProdukView(),
      binding: DataProdukBinding(),
    ),
    GetPage(
      name: _Paths.TENTANG_PAYOO,
      page: () => const TentangPayooView(),
      binding: TentangPayooBinding(),
    ),
    GetPage(
      name: _Paths.TRANSAKSI,
      page: () => const TransaksiView(),
      binding: TransaksiBinding(),
    ),
    GetPage(
      name: _Paths.KERANJANG,
      page: () => const KeranjangView(),
      binding: KeranjangBinding(),
    ),
    GetPage(
      name: _Paths.KOMPOSISI,
      page: () => const KomposisiView(),
      binding: KomposisiBinding(),
    ),
    GetPage(
      name: _Paths.STRUK,
      page: () => const StrukView(),
      binding: StrukBinding(),
    ),
    GetPage(
        name: _Paths.LAPORAN,
        page: () => const LaporanView(),
        binding: LaporanBinding()),
    GetPage(
        name: Routes.TENTANG_PAYOO,
        page: () => const TentangPayooView(),
        binding: TentangPayooBinding()),
    GetPage(
        name: Routes.KERANJANG,
        page: () => const KeranjangView(),
        binding: KeranjangBinding()),
  ];
}
