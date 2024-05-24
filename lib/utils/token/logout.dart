import 'package:byme_flutter_app/utils/token/clear_token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<bool> logOut() async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'token');
  var url = Uri.parse('https://api-py-byme.onrender.com/auth/logout');
  Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
  bool success = false;
  try {
    final response = await http.delete(url, headers: header);
    switch (response.statusCode) {
      case 200:
        try {
          clearToken();
          success = true;
        } catch (error) {
          throw 'Error: $error';
        }
      case 400:
        break;
      case 401:
        break;
      case 500:
        break;
    }
  } catch (error) {
    throw 'Error: $error';
  }
  return success;
}
