import 'package:http/http.dart' as http;
import 'dart:convert';

Future<dynamic> getUserData(int userId) async {
    var url =
        Uri.parse('https://api-py-byme.onrender.com/doctor/select_doctor/$userId');
    const Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',

    };

    try {
      final response = await http.get(url, headers: header);
      
    } catch (error) {
      
    } finally {
      
    }
}