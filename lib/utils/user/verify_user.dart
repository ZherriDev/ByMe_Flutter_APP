import 'package:byme_flutter_app/utils/user/get_user_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<bool> verifyUser() async {
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'token');
  final doctorId = await storage.read(key: 'doctor_id');
  int? doctorIdInt;

  if (doctorId != null && token != null) {
    try {
      doctorIdInt = int.parse(doctorId);
      final _getuserData = await getUserData(token, doctorIdInt);
      bool? isError = _getuserData?['error'];
      if (isError == true) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print('Erro ao converter doctorId para inteiro: $e');
      return false;
    }
  } else {
    return false;
  }
}
