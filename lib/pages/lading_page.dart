import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/byme_logo.jpg"),
                RichText(
                    text: const TextSpan(children: [
                  TextSpan(
                      text: 'A Solução Completa para ',
                      style: TextStyle(fontWeight: FontWeight.normal)),
                  TextSpan(
                      text: 'Gerenciamento de Pacientes e Consultas.',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ])),
                Container(
                  height: 10,
                ),
                const Text(
                  'Facilite sua vida profissional e otimize o atendimento aos seus pacientes com a ByMe, o aplicativo de saúde ideal para médicos.',
                ),
                Container(
                  height: 70,
                ),
                SizedBox(child: Row(
                  children: [
                    ElevatedButton(
                    onPressed: () => Navigator.of(context).pushNamed('/register'), 
                    child: const Text("Registar-me")),
                    ElevatedButton(
                    onPressed: () => Navigator.of(context).pushNamed('/login'), 
                    child: const Text("Iniciar Sessão")),
                  ],
                ),)
              ]),
        ),
      ),
    );
  }
}
