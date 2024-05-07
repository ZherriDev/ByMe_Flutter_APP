import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>?> getUserData(String token, int userId) async {
  var url = Uri.parse(
      'https://api-py-byme.onrender.com/doctor/select_doctor/$userId');
  Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await http.get(url, headers: header);

    
  } catch (error) {
  } finally {}
}
