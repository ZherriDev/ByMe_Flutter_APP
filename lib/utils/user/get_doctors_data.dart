import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>?> getDoctorsData(search) async {
  var url;
  final userStorage = await readToken();
  String token = userStorage?['token'];

  if (search == null) {
    url = Uri.parse('https://api-py-byme.onrender.com/doctor/select_doctors');
  } else {
    url = Uri.parse(
        'https://api-py-byme.onrender.com/doctor/select_doctors/$search');
  }

  Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await http.get(url, headers: header);

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> doctorsData = jsonDecode(response.body);
        return doctorsData;
      case 400:
        print('Dados Incorretos');
        break;
      case 401:
        print('Token Inválido');
        return {'error': true};
      case 500:
        print('Erro no servidor');
        break;
    }
  } catch (error) {
    print('Error: $error');
  }
  return null;
}
