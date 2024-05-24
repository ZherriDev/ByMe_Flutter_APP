import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> writeToken(token, doctorId) async {
  const storage = FlutterSecureStorage();
  await storage.write(key: 'token', value: token);
  await storage.write(key: 'doctor_id', value: doctorId);	
}
