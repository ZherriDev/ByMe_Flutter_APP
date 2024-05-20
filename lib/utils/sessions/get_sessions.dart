import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>?> getUserSessions() async {
  final Map<String, dynamic>? tokenId = await readToken();
  final String token = tokenId?['token'];
  final int doctorId = tokenId?['doctor_id'];

  var url = Uri.parse(
      'https://api-py-byme.onrender.com/sessions/select_sessions/$doctorId');
  Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await http.get(url, headers: header);

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> userSessions = jsonDecode(response.body);
        return userSessions;
      case 400:
        print('Dados Incorretos');
        break;
      case 401:
        print('Token Inválido');
      case 500:
        print('Erro no servidor');
        break;
    }
  } catch (error) {
    print('Error: $error');
  }
  return null;
}
