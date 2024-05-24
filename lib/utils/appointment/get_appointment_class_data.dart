import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

Future<List<dynamic>?> getAppointmentsClassData(
    String query, String date) async {
  final userStorage = await readToken();
  String? token = userStorage?['token'];
  String timeNow = DateFormat('HH:mm:ss').format(DateTime.now());

  if (token == null) {
    print('Token não encontrado');
    return null;
  }

  date = formatDate(date);

  var url = Uri.parse(
      'https://api-py-byme.onrender.com/appointments/select_appointments/$query/$date/$timeNow');
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
        print(appointments);
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

String formatDate(String date) {
  List<String> parts = date.split('-');

  if (parts.length != 3) {
    throw FormatException('Invalid date format');
  }

  String year = parts[0].padLeft(4, '0');
  String month = parts[1].padLeft(2, '0');
  String day = parts[2].padLeft(2, '0');

  DateTime parsedDate =
      DateTime(int.parse(year), int.parse(month), int.parse(day));

  DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(parsedDate);
}
