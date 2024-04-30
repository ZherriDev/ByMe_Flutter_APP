import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 200,
              ),
              Image.asset("assets/images/byme_logo.jpg"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            children: [
                              TextSpan(
                                  text: 'A Solução Completa para ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal)),
                              TextSpan(
                                  text:
                                      'Gerenciamento de Pacientes e Consultas.',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ])),
                    Container(
                      height: 20,
                    ),
                    const Text(
                      'Facilite sua vida profissional e otimize o atendimento aos seus pacientes com a ByMe, o aplicativo de saúde ideal para médicos.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Container(
                height: 200,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).pushReplacementNamed('/register'),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 25)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xff672D6F)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      child: const Text(
                        "Registar-me",
                        style: TextStyle(fontSize: 16),
                      )),
                  Container(
                    width: 50,
                  ),
                  ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).pushReplacementNamed('/login'),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 25)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xff672D6F)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      child: const Text(
                        "Iniciar sessão",
                        style: TextStyle(fontSize: 16),
                      )),
                ],
              ),
            ]),
      ),
    );
  }
}
