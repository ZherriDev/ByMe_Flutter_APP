import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  String? speciality;
  final email = TextEditingController();
  final pass = TextEditingController();
  final confirmPass = TextEditingController();
  bool passVisible = true;
  bool confirmPassVisible = true;
  bool acceptTerms = false;
  bool isLoading = false;
  String message = '';

  final List<String> _specialties = [
    'Clínico Geral',
    'Cardiologista',
    'Dermatologista',
    'Endocrinologista',
    'Gastroenterologista',
    'Ginecologista',
    'Neurologista',
    'Ortopedista',
    'Pediatra',
    'Psiquiatra',
  ];

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

  Future<void> register(name, speciality, email, password) async {
    var url = Uri.parse('https://api-py-byme.onrender.com/auth/register');
    var body = {
      "name": name,
      "speciality": speciality,
      "email": email,
      "password": password,
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
        case 201:
          _showSuccessPopUp(
              'Conta criada com sucesso! Por favor confirme o seu email antes de iniciar sessão.');
          break;
        case 400:
          setState(() {
            message =
                'Os tipos de dados introduzidos não correspondem aos que foram pedidos';
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
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 30,
                  ),
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: Image.asset('assets/images/byme_symbol.png'),
                  ),
                  Container(
                    height: 30,
                  ),
                  TextFormField(
                    enabled: isLoading == false,
                    controller: name,
                    validator: (name) {
                      if (name == null || name.isEmpty) {
                        return 'Insira o seu nome';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary,
                      prefixIcon: const Icon(Icons.person),
                      label: const Text('Nome Completo'),
                      hintText: 'Digite seu nome completo',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Container(
                    height: 15,
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary,
                      prefixIcon: const Icon(Icons.badge_rounded),
                      label: const Text('Especialidade'),
                      hintText: 'Escolha sua especialidade',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    value: speciality,
                    items: _specialties.map((String specialty) {
                      return DropdownMenuItem<String>(
                        value: specialty,
                        child: Text(specialty),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        speciality = newValue!;
                      });
                    },
                    validator: (speciality) {
                      if (speciality == null) {
                        return 'Por favor, selecione uma especialidade';
                      }
                      return null;
                    },
                  ),
                  Container(
                    height: 15,
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
                      fillColor: Theme.of(context).colorScheme.secondary,
                      prefixIcon: const Icon(Icons.email),
                      label: const Text('Email'),
                      hintText: 'exemplo@gmail.com',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Container(
                    height: 15,
                  ),
                  TextFormField(
                    enabled: isLoading == false,
                    obscureText: passVisible,
                    controller: pass,
                    validator: (password) {
                      if (password == null || password.isEmpty) {
                        return 'Insira uma palavra-passe';
                      } else if (password.length < 8) {
                        return 'A Palavra-Passe deve conter no minimo 8 caracteres';
                      } else if (!RegExp(r'[a-z]').hasMatch(password)) {
                        return 'A Palavra-Passe deve conter pelo menos 1 letra minúscula';
                      } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
                        return 'A Palavra-Passe deve conter pelo menos 1 letra maiúscula';
                      } else if (!RegExp(r'\d').hasMatch(password)) {
                        return 'A Palavra-Passe deve conter pelo menos 1 número';
                      } else if (!RegExp(r'[^\w\s]').hasMatch(password)) {
                        return 'A Palavra-Passe deve conter pelo menos 1 símbolo';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary,
                      prefixIcon: const Icon(Icons.lock),
                      label: const Text('Palavra-passe'),
                      hintText: 'Digite sua Palavra-Passe',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            passVisible = !passVisible;
                          });
                        },
                        icon: Icon(
                          passVisible ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Container(
                    height: 15,
                  ),
                  TextFormField(
                    enabled: isLoading == false,
                    obscureText: confirmPassVisible,
                    controller: confirmPass,
                    validator: (confirmPass) {
                      if (confirmPass == null || confirmPass.isEmpty) {
                        return 'É preciso confirmar a palavra-passe';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.secondary,
                      prefixIcon: const Icon(Icons.lock),
                      label: const Text('Confirmação da palavra-passe'),
                      hintText: 'Confirme sua palavra-passe',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            confirmPassVisible = !confirmPassVisible;
                          });
                        },
                        icon: Icon(
                          confirmPassVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 16),
                              children: const [
                            TextSpan(
                                text: "Concordo com os ",
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                            TextSpan(
                                text: "Termos de Serviço",
                                style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline)),
                          ])),
                      Checkbox(
                        value: acceptTerms,
                        onChanged: (value) {
                          setState(() {
                            acceptTerms = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                          message = "";
                        });
                        if (pass.text != confirmPass.text) {
                          setState(() {
                            message = "As palavras-passe não coincidem-se";
                            isLoading = false;
                          });
                        } else if (acceptTerms == false) {
                          setState(() {
                            message =
                                "Os termos de serviço precisam ser aceitos";
                            isLoading = false;
                          });
                        } else {
                          register(
                              name.text, speciality, email.text, pass.text);
                        }
                      }
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 25)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xff672D6F)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLoading ? '' : 'Criar conta',
                            style: const TextStyle(fontSize: 18),
                          ),
                          if (isLoading)
                            const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                        ]),
                  ),
                  Container(
                    height: 8,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                      child: const Text(
                        'Já possui uma conta? Iniciar sessão',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
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
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }
}
