class ValidationUtil {
  /// Validasi input login
  static String validateLogin(String username, String password) {
    if (username.isEmpty || password.isEmpty) {
      return "Username dan Password tidak boleh kosong.";
    }
    return "";
  }

  /// Validasi input registrasi
  static String validateRegistration({
    required String nama,
    required String noTelpon,
    required String alamat,
    required String username,
    required String password,
    required String email,
    required String role,
  }) {
    // Validasi username
    if (username.length < 5) {
      return "Username harus memiliki setidaknya 5 karakter.";
    } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(username)) {
      return "Username hanya boleh mengandung huruf dan angka.";
    }

    // Validasi email
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(email)) {
      return "Email tidak valid.";
    }

    // Validasi password
    if (password.length < 8) {
      return "Password harus memiliki setidaknya 8 karakter.";
    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$')
        .hasMatch(password)) {
      return "Password harus mengandung huruf besar, huruf kecil, angka, dan karakter khusus.";
    }

    // Validasi lainnya
    if (nama.isEmpty) {
      return "Nama tidak boleh kosong.";
    }

    if (noTelpon.isEmpty || noTelpon.length < 10) {
      return "Nomor telepon harus valid.";
    }

    if (alamat.isEmpty) {
      return "Alamat tidak boleh kosong.";
    }

    if (role.isEmpty) {
      return "Role tidak boleh kosong.";
    }

    return "";
  }
}
