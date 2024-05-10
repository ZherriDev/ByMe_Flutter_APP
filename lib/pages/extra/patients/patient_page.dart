import 'package:flutter/material.dart';

class PatientPage extends StatefulWidget {
  final int? patientId;
  final PageController pageController;

  const PatientPage({Key? key, this.patientId, required this.pageController})
      : super(key: key);

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Details'),
      ),
      body: Center(
        child: Text('Patient ID: ${widget.patientId}'),
      ),
    );
  }
}
