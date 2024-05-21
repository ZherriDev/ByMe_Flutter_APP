import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>?> getAppointmentsClassData(
    String query, String date) async {
  final userStorage = await readToken();
  String? token = userStorage?['token'];

  if (token == null) {
    print('Token não encontrado');
    return null;
  }

  var url = Uri.parse(
      'https://api-py-byme.onrender.com/appointments/select_appointments/$query/$date');
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await http.get(url, headers: headers);

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> appointmentData = jsonDecode(response.body);
        final List<dynamic>? appointments = appointmentData['appointments'];
        return appointments;
      case 400:
        print('Dados Incorretos');
        break;
      case 401:
        print('Token Inválido');
        break;
      case 500:
        print('Erro no servidor');
        break;
      default:
        print('Erro desconhecido: ${response.statusCode}');
    }
  } catch (error) {
    print('Erro: $error');
  }
  return null;
}
