import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<bool> verifyUser() async {
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'token');
  if (token != null) {
    return true;
  } else {
    return false;
  }
}
