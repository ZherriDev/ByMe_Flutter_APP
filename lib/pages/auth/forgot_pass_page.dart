import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  String message = '';
  bool isLoading = false;

  void _showSuccessPopUp(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: SizedBox(
            width: 150,
            height: 150,
            child: Image.asset('assets/images/success.png'),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pushNamed('/login');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> forgotPass(email) async {
    var url =
        Uri.parse('https://api-py-byme.onrender.com/auth/request_reset_pass');
    var body = {
      "email": email,
    };
    const Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: header,
      );
      switch (response.statusCode) {
        case 200:
          _showSuccessPopUp(
              'Um e-mail de redefinição de palavra-passe foi enviado. Por favor verifique sua caixa de entrada.');
          break;
        case 400:
          setState(() {
            message = 'O email não foi encontrado.';
          });
          break;
        case 429:
          setState(() {
            message = 'Muitas requisições, tente novamente em 1 minuto.';
          });
          break;
        case 500:
          setState(() {
            message = 'Algo correu mal.';
          });
          break;
      }
    } catch (error) {
      setState(() {
        message = 'Erro de conexão. Verifique sua conexão com a internet.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 50,
              ),
              Image.asset('assets/images/forgot_password.png'),
              const Text(
                "Esqueceu a Palavra-passe?",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Container(
                height: 20,
              ),
              RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      children: [
                        TextSpan(
                            text: "Introduza seu e-mail ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: "para receber um ",
                            style: TextStyle(fontWeight: FontWeight.normal)),
                        TextSpan(
                            text: "e-mail de recuperação de palavra-passe.",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ])),
              Container(
                height: 20,
              ),
              TextFormField(
                enabled: isLoading == false,
                controller: email,
                validator: (email) {
                  if (email == null || email.isEmpty) {
                    return 'Insira o seu email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: const Icon(Icons.email),
                  label: const Text('E-mail'),
                  hintText: 'Digite seu email',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Container(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                      message = "";
                    });
                    forgotPass(email.text);
                  }
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 25)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xff672D6F)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    isLoading ? '' : 'Enviar E-mail',
                    style: const TextStyle(fontSize: 18),
                  ),
                  if (isLoading)
                    const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                ]),
              ),
              Container(
                height: 10,
              ),
              Visibility(
                visible: message.isNotEmpty,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.red),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
