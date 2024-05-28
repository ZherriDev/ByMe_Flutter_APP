import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> updateSession(sessionId) async {
  final Map<String, dynamic>? tokenId = await readToken();
  final String token = tokenId?['token'];
  bool success = false;

  var url =
      Uri.parse('https://api-py-byme.onrender.com/sessions/update_session');
  Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
  var body = {
    "session_id": sessionId,
  };
  try {
    final response =
        await http.patch(url, headers: header, body: jsonEncode(body));

    switch (response.statusCode) {
      case 200:
        success = true;
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
