import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<Map<String, dynamic>?> readToken() async {
  final storage = FlutterSecureStorage();

  // Read the token and doctor ID asynchronously
  final token = await storage.read(key: 'token');
  final doctorIdStr = await storage.read(key: 'doctor_id');

  int? doctorIdInt;
  if (doctorIdStr != null) {
    doctorIdInt = int.parse(doctorIdStr);
  }

  return {
    'token': token,
    'doctor_id': doctorIdInt,
  };
}
