import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>?> getUserData(String token, int doctorId) async {
  var url = Uri.parse(
      'https://api-py-byme.onrender.com/doctor/select_doctor/$doctorId');
  Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await http.get(url, headers: header);

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> userData = jsonDecode(response.body);
        return userData;
      case 400:
        print('Dados Incorretos');
        break;
      case 500:
        print('Erro no servidor');
        break;
    }
  } catch (error) {
    print('Error: $error');
  }
  return null;
}
