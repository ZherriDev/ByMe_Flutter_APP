import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> updateImage(String name, int? phone, String? birthdate,
    String? address, String speciality, String photo, String? sex) async {
  final userStorage = await readToken();
  String token = userStorage?['token'];
  int doctorId = userStorage?['doctor_id'];
  bool succes = false;
  var url = Uri.parse('https://api-py-byme.onrender.com/doctor/update_doctor');
  var body = {
    "doctor_id": doctorId,
    "fullname": name,
    "photo": photo,
    "telephone": phone,
    "sex": sex,
    "birthdate": birthdate,
    "address": address,
    "speciality": speciality
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
        succes = true;
      case 400:
        print('Error: ${response.body}');
        break;
      case 401:
        print('Error: ${response.statusCode}');
        break;
      case 500:
        print('Error: ${response.statusCode}');
        break;
    }
  } catch (error) {
    throw 'Error: $error';
  }
  return succes;
}
