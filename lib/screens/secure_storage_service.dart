import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  // Save password securely
  Future<void> storePassword(String password) async {
    await _storage.write(key: 'user_password', value: password);
  }

  // Retrieve password
  Future<String?> getPassword() async {
    return await _storage.read(key: 'user_password');
  }

  // Delete password (optional, for logout or reset functionality)
  Future<void> deletePassword() async {
    await _storage.delete(key: 'user_password');
  }
}
