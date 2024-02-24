import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  TokenManager._internal();

  factory TokenManager() {
    return _instance;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: "idToken");
  }

  Future<void> setToken(String idToken) async {
    await _storage.write(key: "idToken", value: idToken);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: "idToken");
  }

  Future<String?> getFcmToken() async {
    return await _storage.read(key: "fcmToken");
  }

  Future<void> setFcmToken(String fcmToken) async {
    await _storage.write(key: "fcmToken", value: fcmToken);
  }

  Future<void> deleteFcmToken() async {
    await _storage.delete(key: "fcmToken");
  }
}
