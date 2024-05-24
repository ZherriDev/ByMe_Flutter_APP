import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

Future<Map<String, dynamic>?> getAppointmentsData(
    String query, String date) async {
  final userStorage = await readToken();
  String token = userStorage?['token'];
  String timeNow = DateFormat('HH:mm:ss').format(DateTime.now());

  var url = Uri.parse(
      'https://api-py-byme.onrender.com/appointments/select_appointments/$query/$date/$timeNow');
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
        return null;
      case 401:
        return null;
      case 500:
        return null;
    }
  } catch (error) {
    throw 'Error: $error';
  }
  return null;
}
