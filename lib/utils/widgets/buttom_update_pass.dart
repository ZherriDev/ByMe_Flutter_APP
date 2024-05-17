import "package:flutter/material.dart";
import 'package:byme_flutter_app/utils/token/clear_token.dart';
import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdatePass extends StatefulWidget {
  final void Function(String message, bool succes, String navigator) showSuccessPopUp;
  final GlobalKey<FormState> formKey;
  final TextEditingController oldpassController;
  final TextEditingController newpassController;
  final TextEditingController confirmnewpassController;

  const UpdatePass({
    required this.formKey,
    required this.oldpassController,
    required this.newpassController,
    required this.confirmnewpassController,
    required this.showSuccessPopUp,
  });

  @override
  State<UpdatePass> createState() => _UpdatePassState();
}

class _UpdatePassState extends State<UpdatePass> {
  bool _isLoading = false;
  String _errorMessage = '';

  Future<bool> updatePass(String oldPassword, String newPassword) async {
    final userStorage = await readToken();
    String token = userStorage?['token'];
    int doctorId = userStorage?['doctor_id'];
    bool _succes = false;

    var url =
        Uri.parse('https://api-py-byme.onrender.com/auth/change_password');
    ;
    var body = {
      "doctor_id": doctorId,
      "old_password": oldPassword,
      "new_password": newPassword,
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
          clearToken();
          _succes = true;
        case 400:
          setState(() {
            _errorMessage = 'Requisição Inválida';
          });

          break;
        case 401:
          setState(() {
            _errorMessage = 'Palavra-Passe antiga incorreta';
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
            updatePass(
              widget.oldpassController.text,
              widget.newpassController.text,
            ).then((succes) {
              if (succes) {
                setState(() {
                  _isLoading = false;
                });
                widget.showSuccessPopUp(
                    'Informações atualizadas com sucesso\n'
                    'Pra sua segurança a sua sessão será encerrada',
                    true,
                    'password');
              } else {
                setState(() {
                  _isLoading = false;
                });
                widget.showSuccessPopUp(_errorMessage, false, 'password');
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
