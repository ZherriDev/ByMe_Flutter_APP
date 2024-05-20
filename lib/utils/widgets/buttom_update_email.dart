import "package:flutter/material.dart";
import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateEmail extends StatefulWidget {
  final void Function(String message, bool succes, String navigator)
      showSuccessPopUp;
  final GlobalKey<FormState> formKey;
  final TextEditingController oldEmaiController;
  final TextEditingController newEmailController;

  const UpdateEmail({
    required this.formKey,
    required this.oldEmaiController,
    required this.newEmailController,
    required this.showSuccessPopUp,
  });

  @override
  State<UpdateEmail> createState() => _UpdateEmailState();
}

class _UpdateEmailState extends State<UpdateEmail> {
  bool _isLoading = false;
  String _errorMessage = '';

  Future<bool> updateEmail(String oldEmail, String newEmail) async {
    final userStorage = await readToken();
    String token = userStorage?['token'];
    int doctorId = userStorage?['doctor_id'];
    bool _succes = false;
    var url = Uri.parse('https://api-py-byme.onrender.com/auth/change_email');
    ;
    var body = {
      "doctor_id": doctorId,
      "old_email": oldEmail,
      "new_email": newEmail,
    };

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: header,
      );

      switch (response.statusCode) {
        case 200:
          setState(() {
            _errorMessage = 'Sucesso\n'
                'Verifique a caixa de entrada do seu\n'
                'novo E-mail';
          });
          _succes = true;
        case 400:
          setState(() {
            _errorMessage = 'Requisição Inválida';
          });

          break;
        case 401:
          setState(() {
            _errorMessage = 'E-mail antigo incorreto';
          });

          break;
        case 500:
          setState(() {
            _errorMessage = 'Algo correu mal';
          });
          break;
        case 405:
          print('Método não permitido');
          break;
      }
    } catch (error) {
      print('Error: $error');
    }
    return _succes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: ElevatedButton(
        onPressed: () {
          if (widget.formKey.currentState!.validate()) {
            setState(() {
              _isLoading = true;
            });
            updateEmail(
              widget.oldEmaiController.text,
              widget.newEmailController.text,
            ).then((succes) {
              if (succes) {
                setState(() {
                  _isLoading = false;
                });
                widget.showSuccessPopUp(_errorMessage, true, 'e-mail');
              } else {
                setState(() {
                  _isLoading = false;
                });
                widget.showSuccessPopUp(_errorMessage, false, 'e-mail');
              }
            });
          }
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor:
              MaterialStateProperty.all<Color>(const Color(0xff672D6F)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            _isLoading ? '' : 'Salvar',
            style: const TextStyle(fontSize: 18),
          ),
          if (_isLoading)
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
        ]),
      ),
    );
  }
}
