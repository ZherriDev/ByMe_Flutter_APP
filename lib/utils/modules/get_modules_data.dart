import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>?> getModulesData(int patientId) async {
  final userStorage = await readToken();
  String token = userStorage?['token'];

  var url = Uri.parse(
      'https://api-py-byme.onrender.com/module/select_modules/$patientId');

  Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await http.get(url, headers: header);

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> modulesData = jsonDecode(response.body);
        return modulesData;
      case 400:
        return null;
      case 401:
        return null;
      case 500:
        return null;
    }
  } catch (error) {
    throw 'Error: $error';
  }
  return null;
}
