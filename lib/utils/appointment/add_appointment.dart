import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> addAppointment(
    int patientId, String subject, String date, String time) async {
  final userStorage = await readToken();
  String token = userStorage?['token'];
  int doctorId = userStorage?['doctor_id'];

  var url = Uri.parse(
      'https://api-py-byme.onrender.com/appointments/insert_appointments');

  var body = {
    "patient_id": patientId,
    "doctor_id": doctorId,
    "subject": subject,
    "date": date,
    "time": time
  };

  Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    final response =
        await http.post(url, headers: header, body: jsonEncode(body));

    switch (response.statusCode) {
      case 201:
        return true;
      case 400:
        return false;
      case 401:
        return false;
      case 500:
        return false;
    }
  } catch (error) {
    throw 'Error: $error';
  }
  return false;
}
