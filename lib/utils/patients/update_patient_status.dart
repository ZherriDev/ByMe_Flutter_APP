import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:byme_flutter_app/utils/token/read_token.dart';

class UpdatePatientStatus extends StatefulWidget {
  final BuildContext context;
  final int patientId;
  final Map<String, dynamic> patient;
  final Function() reloadPage;

  const UpdatePatientStatus(
      {Key? key,
      required this.context,
      required this.patientId,
      required this.patient,
      required this.reloadPage})
      : super(key: key);

  @override
  State<UpdatePatientStatus> createState() => _UpdatePatientStatusState();
}

class _UpdatePatientStatusState extends State<UpdatePatientStatus> {
  bool isLoading = false;

  final List<String> _status = [
    'Awaiting Treatment',
    'In Treatment',
    'Completed Treatment'
  ];

  Future<bool?> updatePatientStatus(patientId, status) async {
    Map<String, dynamic>? userStorage = await readToken();
    String token = userStorage?['token'];

    var url = Uri.parse(
        'https://api-py-byme.onrender.com/patient/update_patient_status');

    var body = {"patient_id": patientId, "status": status};

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.patch(
        url,
        body: jsonEncode(body),
        headers: header,
      );
      switch (response.statusCode) {
        case 200:
          return true;
        case 400:
          return false;
        case 429:
          return false;
        case 500:
          return false;
      }
    } catch (error) {
      print(error);
      return false;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    String status = widget.patient['status'];

    return AlertDialog(
        title: Text(
          'Mudar para qual estado?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Stack(
          children: [
            Form(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[400]?.withOpacity(0.3),
                  prefixIcon: Icon(Icons.info),
                  hintText: 'Estado do paciente',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: status,
                items: _status.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(
                      status == 'Awaiting Treatment'
                          ? 'Aguardando tratamento'
                          : status == 'In Treatment'
                              ? 'Em tratamento'
                              : 'Tratamento concluído',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    status = newValue!;
                    isLoading = true;
                  });
                  updatePatientStatus(widget.patientId, status).then((success) {
                    if (success == true) {
                      Navigator.of(context).pop();
                      widget.reloadPage();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text('Estado do paciente atualizado com sucesso.'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ));
                    } else {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Não foi possível atualizar o estado do paciente.'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ));
                    }
                  });
                },
                validator: (status) {
                  if (status == null) {
                    return 'Por favor, selecione o estado do paciente';
                  }
                  return null;
                },
              ),
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.grey.withOpacity(0.3),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ));
  }
}
