import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<bool> clearToken() async {
  try {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
    await storage.delete(key: 'doctor_id');

    return true;
  } catch (Exception) {
    print('Error while deleting token ${Exception}.');
    return false;
  }
}
