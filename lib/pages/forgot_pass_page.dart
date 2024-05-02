import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
              onChanged: (text) {
                email = text;
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
                if (email.isEmpty ||
                    !RegExp(r"[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$")
                        .hasMatch(email)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email Inválido'),
                    ),
                  );
                  return;
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Email de recuperação de palavra-passe enviado'),
                  ),
                );
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xff672D6F)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              child: const Text(
                'Enviar E-mail',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
