import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:flutter/material.dart';

class ConfirmTransfer extends StatefulWidget {
  final BuildContext context;
  final String fullname;
  final int patientId;
  final int doctorId;
  final PageController pageController;

  const ConfirmTransfer(
      {Key? key,
      required this.context,
      required this.fullname,
      required this.patientId,
      required this.doctorId,
      required this.pageController})
      : super(key: key);

  @override
  State<ConfirmTransfer> createState() => _ConfirmTransferState();
}

class _ConfirmTransferState extends State<ConfirmTransfer> {
  bool isLoading = false;

  Future<bool?> transferPatient(int patientId, int doctorId) async {
    final userStorage = await readToken();
    String token = userStorage?['token'];

    var url = Uri.parse(
        'https://api-py-byme.onrender.com/patient/update_patient_doctor');

    var body = {"patient_id": patientId, "doctor_id": doctorId};

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response =
          await http.patch(url, body: jsonEncode(body), headers: header);

      switch (response.statusCode) {
        case 200:
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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: SizedBox(
        width: 150,
        height: 150,
        child: Image.asset('assets/images/warning.png'),
      ),
      content: Text(
        'Tem certeza que deseja transferir o paciente para o doutor ${widget.fullname}?',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Não'),
          onPressed: () {
            Navigator.of(widget.context).pop();
          },
        ),
        TextButton(
          child: isLoading
              ? const CircularProgressIndicator(
                  strokeWidth: 2,
                )
              : const Text('Sim'),
          onPressed: () {
            setState(() {
              isLoading = true;
            });
            transferPatient(widget.patientId, widget.doctorId).then((success) {
              if (success == true) {
                Navigator.of(widget.context).pop();
                widget.pageController.jumpToPage(2);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Paciente transferido com sucesso.'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ));
              } else {
                Navigator.of(widget.context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Não foi possível transferir o paciente.'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                ));
              }
            });
          },
        ),
      ],
    );
  }
}
