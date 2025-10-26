import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payoo/config/utils/storage_manager.dart';
import 'package:payoo/app/routes/app_pages.dart';

/// Middleware untuk memproteksi route yang butuh login
class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // Cek apakah user sudah login
    final isLoggedIn = StorageManager().read('isLoggedIn') ?? false;
    
    // Jika belum login, redirect ke login page
    if (!isLoggedIn) {
      return const RouteSettings(name: Routes.LOGIN);
    }
    
    // Jika sudah login, lanjutkan ke route yang diminta
    return null;
  }
}

/// Middleware untuk login page (jika sudah login, langsung ke home)
class LoginMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // Cek apakah user sudah login
    final isLoggedIn = StorageManager().read('isLoggedIn') ?? false;
    
    // Jika sudah login, redirect ke home
    if (isLoggedIn) {
      return const RouteSettings(name: Routes.DASHBOARD);
    }
    
    // Jika belum login, tampilkan login page
    return null;
  }
}