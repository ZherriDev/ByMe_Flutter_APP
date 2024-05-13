import 'package:flutter/material.dart';
import 'package:byme_flutter_app/utils/token/read_token.dart';

Future<Map<String, dynamic>?> fetchPatientData(BuildContext context, int patientId) async {
  try {
    final userStorage = await readToken();
    String token = userStorage?['token'];
    int doctorId = userStorage?['doctor_id'];



    // final data = {'patient': patient, 'modules': modules};

    return null;
  } catch (e) {
    print('Erro ao obter dados do paciente: $e');
    return null;
  }
}