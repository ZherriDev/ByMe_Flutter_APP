import 'package:byme_flutter_app/utils/token/clear_token.dart';
import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> updatePass(String oldPassword, String newPassword) async {
  final userStorage = await readToken();
  String token = userStorage?['token'];
  int doctorId = userStorage?['doctor_id'];
  bool succes = false;
  var url = Uri.parse('https://api-py-byme.onrender.com/auth/change_password');
  var body = {
    "doctor_id": doctorId,
    "old_password": oldPassword,
    "new_password": newPassword,
  };

  Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await http.post(
      url,
      body: jsonEncode(body),
      headers: header,
    );

    clearToken();

    switch (response.statusCode) {
      case 200:
        succes = true;
      case 400:
        break;
      case 401:
        break;
      case 500:
        break;
      case 405:
        break;
    }
  } catch (error) {
    throw 'Error: $error';
  }
  return succes;
}
