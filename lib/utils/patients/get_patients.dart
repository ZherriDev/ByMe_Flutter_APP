import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>?> getPatients(
    String token, int doctorId, order, state) async {
  var url;

  if (order == null && state == null) {
    url = Uri.parse(
        'https://api-py-byme.onrender.com/patient/select_patient/$doctorId');
  } else {
    url = Uri.parse(
        'https://api-py-byme.onrender.com/patient/select_patient/$doctorId/$order/$state');
  }
  Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await http.get(url, headers: header);

    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> patientData = jsonDecode(response.body);
        return patientData;
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
