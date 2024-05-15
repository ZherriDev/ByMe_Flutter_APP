import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> updateEmail(String oldEmail, String newEmail) async {
  final userStorage = await readToken();
  String token = userStorage?['token'];
  int doctorId = userStorage?['doctor_id'];
  bool _succes = false;
  var url = Uri.parse('https://api-py-byme.onrender.com/doctor/change_email');
  ;
  var body = {
    "doctor_id": doctorId,
    "old_email": oldEmail,
    "new_email": newEmail,
  };

  Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await http.patch(
      url,
      body: jsonEncode(body),
      headers: header,
    );

    switch (response.statusCode) {
      case 200:
        _succes = true;
      case 400:
        print('Requisição Inválida');
        break;
      case 401:
        print('Token Inválido');
        break;
      case 500:
        print('Erro no servidor');
        break;
    }
  } catch (error) {
    print('Error: $error');
  }
  return _succes;
}
