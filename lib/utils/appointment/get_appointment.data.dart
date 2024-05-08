import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>?> getAppointmentsData(
    String token, int doctorId, String query, String date) async {
  var url = Uri.parse(
      'https://api-py-byme.onrender.com/appointments/select_appointments/$query/$date');
  Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await http.get(url, headers: header);

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> appointmentData = jsonDecode(response.body);
        return appointmentData;
      case 400:
        print('Dados Incorretos');
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
  }
  return null;
}
