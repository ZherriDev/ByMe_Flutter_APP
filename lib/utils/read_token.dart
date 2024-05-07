import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> writeToken() async {
  final storage = FlutterSecureStorage();
  
  String token = await storage.read(key: 'token');
  Int doctorId = await storage.read(key: 'doctor_id');


}
