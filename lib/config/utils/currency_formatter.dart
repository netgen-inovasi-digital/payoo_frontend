import 'dart:math' as math;

class CurrencyFormatter {
  /// Format number to Rupiah currency format
  /// 
  /// Example:
  /// - formatRupiah(1000) -> "Rp. 1.000"
  /// - formatRupiah(1500000) -> "Rp. 1.500.000"
  /// - formatRupiah(1234.56) -> "Rp. 1.235" (rounded)
  static String formatRupiah(dynamic value) {
    if (value == null) return 'Rp. 0';
    
    // Convert to double
    double numValue;
    if (value is int) {
      numValue = value.toDouble();
    } else if (value is double) {
      numValue = value;
    } else if (value is String) {
      numValue = double.tryParse(value) ?? 0.0;
    } else {
      numValue = 0.0;
    }
    
    // Round to nearest integer
    int roundedValue = numValue.round();
    
    // Handle negative values
    bool isNegative = roundedValue < 0;
    int absValue = roundedValue.abs();
    
    // Convert to string and add thousand separators
    String valueStr = absValue.toString();
    String formattedValue = _addThousandSeparators(valueStr);
    
    // Add currency symbol and format
    String result = 'Rp. $formattedValue';
    
    // Add negative sign if needed
    if (isNegative) {
      result = '-$result';
    }
    
    return result;
  }
  
  /// Format number to Rupiah currency format without decimal places
  /// 
  /// Example:
  /// - formatRupiahSimple(1000) -> "Rp. 1.000"
  /// - formatRupiahSimple(1500000) -> "Rp. 1.500.000"
  static String formatRupiahSimple(dynamic value) {
    if (value == null) return 'Rp. 0';
    
    // Convert to double
    double numValue;
    if (value is int) {
      numValue = value.toDouble();
    } else if (value is double) {
      numValue = value;
    } else if (value is String) {
      numValue = double.tryParse(value) ?? 0.0;
    } else {
      numValue = 0.0;
    }
    
    // Round to nearest integer
    int roundedValue = numValue.round();
    
    // Handle negative values
    bool isNegative = roundedValue < 0;
    int absValue = roundedValue.abs();
    
    // Convert to string and add thousand separators
    String valueStr = absValue.toString();
    String formattedValue = _addThousandSeparators(valueStr);
    
    // Add currency symbol
    String result = 'Rp. $formattedValue';
    
    // Add negative sign if needed
    if (isNegative) {
      result = '-$result';
    }
    
    return result;
  }
  
  /// Format number with thousand separators only (no currency symbol)
  /// 
  /// Example:
  /// - formatNumber(1000) -> "1.000"
  /// - formatNumber(1500000) -> "1.500.000"
  static String formatNumber(dynamic value) {
    if (value == null) return '0';
    
    // Convert to double
    double numValue;
    if (value is int) {
      numValue = value.toDouble();
    } else if (value is double) {
      numValue = value;
    } else if (value is String) {
      numValue = double.tryParse(value) ?? 0.0;
    } else {
      numValue = 0.0;
    }
    
    // Round to nearest integer
    int roundedValue = numValue.round();
    
    // Handle negative values
    bool isNegative = roundedValue < 0;
    int absValue = roundedValue.abs();
    
    // Convert to string and add thousand separators
    String valueStr = absValue.toString();
    String formattedValue = _addThousandSeparators(valueStr);
    
    // Add negative sign if needed
    if (isNegative) {
      formattedValue = '-$formattedValue';
    }
    
    return formattedValue;
  }
  
  /// Add thousand separators (dots) to a number string
  /// 
  /// Example:
  /// - _addThousandSeparators("1000") -> "1.000"
  /// - _addThousandSeparators("1234567") -> "1.234.567"
  static String _addThousandSeparators(String value) {
    // Use regex to add dots every 3 digits from right
    return value.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }
  
  /// Parse Rupiah string back to double
  /// 
  /// Example:
  /// - parseRupiah("Rp. 1.000") -> 1000.0
  /// - parseRupiah("1.500.000") -> 1500000.0
  static double parseRupiah(String rupiahString) {
    if (rupiahString.isEmpty) return 0.0;
    
    // Remove all non-digit characters except minus sign
    String cleanString = rupiahString
        .replaceAll(RegExp(r'[^\d-]'), '')
        .replaceAll('.', '');
    
    return double.tryParse(cleanString) ?? 0.0;
  }
}

// Global convenience functions for easy access
String formatRupiah(dynamic value) => CurrencyFormatter.formatRupiah(value);
String formatRupiahSimple(dynamic value) => CurrencyFormatter.formatRupiahSimple(value);
String formatNumber(dynamic value) => CurrencyFormatter.formatNumber(value);
double parseRupiah(String rupiahString) => CurrencyFormatter.parseRupiah(rupiahString);