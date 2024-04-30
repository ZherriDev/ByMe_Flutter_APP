import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  final backgroundColor = const Color(0xFF672D6F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  label: Text('E-mail'),
                  hintText: 'exemplo@gmail.com',
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  label: Text('Palavra-Passe'),
                  hintText: 'Digite sua Palavra-Passe',
                ),
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor,
                  foregroundColor: Colors.white,

                ),
                child: Text('Acessar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
