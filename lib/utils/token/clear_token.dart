import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<bool> clearToken() async {
  try {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
    await storage.delete(key: 'doctor_id');

    return true;
  } catch (e) {
    throw 'Error while deleting token $e.';
  }
}
