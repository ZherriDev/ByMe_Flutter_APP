import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> updateData(
    name, phone, birthdate, address, speciality, photo, sex) async {
 
  final userStorage = await readToken();
  String token = userStorage?['token'];
  bool _succes = false;
   var url = Uri.parse(
      'https://api-py-byme.onrender.com/doctor/update_doctor');
  ;
  var body = {
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

    final response = await http.post(
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
    _succes = false;
  }
  return _succes;
}
