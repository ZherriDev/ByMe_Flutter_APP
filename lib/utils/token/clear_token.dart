import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> clearToken() async {
  final storage = FlutterSecureStorage();
  await storage.delete(key: 'token');
}
