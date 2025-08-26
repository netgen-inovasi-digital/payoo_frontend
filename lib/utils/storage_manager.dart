import 'package:get_storage/get_storage.dart';

class StorageManager {
  final GetStorage _storage = GetStorage();

  // Singleton pattern
  static final StorageManager _instance = StorageManager._internal();

  factory StorageManager() {
    return _instance;
  }

  StorageManager._internal();

  /// Save data to storage
  void save(String key, dynamic value) {
    _storage.write(key, value);
  }

  /// Read data from storage
  T? read<T>(String key) {
    return _storage.read<T>(key);
  }

  /// Delete a specific key from storage
  void delete(String key) {
    _storage.remove(key);
  }

  /// Clear all data from storage
  void clear() {
    _storage.erase();
  }

  /// Check if a key exists in storage
  bool contains(String key) {
    return _storage.hasData(key);
  }
}
