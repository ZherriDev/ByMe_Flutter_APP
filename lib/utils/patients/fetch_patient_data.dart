import 'package:byme_flutter_app/utils/modules/get_modules_data.dart';
import 'package:byme_flutter_app/utils/patients/get_patient_data.dart';
import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> fetchPatientData(
    BuildContext context, int patientId) async {
  try {

    final patient = await getPatientData(patientId);
    final modules = await getModulesData(patientId);
    
    final data = {'patient': patient, 'modules': modules};

    return data;
  } catch (e) {
    print('Erro ao obter dados do paciente: $e');
    return null;
  }
}
