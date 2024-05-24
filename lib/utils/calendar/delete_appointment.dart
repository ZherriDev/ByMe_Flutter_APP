import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeleteAppointment extends StatefulWidget {
  final BuildContext context;
  final int appointmentId;
  final PageController pageController;
  final Function() reloadPage;

  const DeleteAppointment(
      {Key? key,
      required this.context,
      required this.appointmentId,
      required this.pageController,
      required this.reloadPage})
      : super(key: key);

  @override
  State<DeleteAppointment> createState() => _DeleteAppointmentState();
}

class _DeleteAppointmentState extends State<DeleteAppointment> {
  bool isLoading = false;

  Future<bool?> deleteAppointment(int appointmentId) async {
    final userStorage = await readToken();
    String token = userStorage?['token'];

    var url = Uri.parse(
        'https://api-py-byme.onrender.com/appointments/delete_appointment');

    var body = {"appointment_id": appointmentId};

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response =
          await http.delete(url, body: jsonEncode(body), headers: header);

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
      content: const Text(
        'Você não poderá voltar atrás com esta ação. Tem certeza que deseja cancelar esta consulta?',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            deleteAppointment(widget.appointmentId).then((success) {
              if (success == true) {
                Navigator.of(widget.context).pop();
                widget.reloadPage();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Consulta cancelada com sucesso.'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ));
              } else {
                Navigator.of(widget.context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Não foi possível cancelar a consulta.'),
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
