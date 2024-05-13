import 'package:byme_flutter_app/utils/patients/fetch_patient_data.dart';
import 'package:flutter/material.dart';

class PatientPage extends StatefulWidget {
  final int patientId;
  final PageController pageController;

  const PatientPage(
      {Key? key, required this.patientId, required this.pageController})
      : super(key: key);

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchPatientData(context, widget.patientId),
        builder: (context, snapshot) {
          return Container();
        });
  }
}
