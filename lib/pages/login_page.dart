import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const TextStyle blackLabelStyle = TextStyle(color: Colors.black);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final colorPurple = const Color(0xFF672D6F);
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = true;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<bool> login() async {
    setState(() {
      _isLoading = true;
    });

    bool successLogin = false;

    const Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    var url = Uri.parse('https://api-py-byme.onrender.com/auth/login');
    var body = {
      "email": _emailController.text,
      "password": _passwordController.text,
      "ip_address": "192.168.1.1",
      "device": "Linux",
      "operational_system": "Android",
      "location": "Portugal",
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: header,
      );

      switch (response.statusCode) {
        case 200:
          try {
            final storage = FlutterSecureStorage();
            String token = jsonDecode(response.body)['token'];
            await storage.write(key: 'token', value: token);
            setState(() {
              _errorMessage = '';
              successLogin = true;
            });
          } catch (error) {
            setState(() {
              _errorMessage = 'Erro ao salver JWT. Error: $error';
              successLogin = false;
            });
          }
          break;
        case 400:
          setState(() {
            _errorMessage = 'Requisição inválida';
            successLogin = false;
          });

          break;
        case 401:
          setState(() {
            _errorMessage = 'Credenciais Inválidas';
            successLogin = false;
          });
          break;
        case 429:
          setState(() {
            _errorMessage =
                'Muitas requisições, tente novamente dentro de 1 minuto';
            successLogin = false;
          });
          break;
        case 500:
          setState(() {
            _errorMessage = 'Algo correu mal';
            successLogin = false;
          });
          break;
      }

      print(response.statusCode);
      print(response.body);
    } catch (error) {
      _errorMessage = 'Erro de Conexão. Verifique sua conexão com a internet.';
      successLogin = false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    return successLogin;
  }

  @override
  void _toggleObscured() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: LoginPage.blackLabelStyle, // Hint text color
        ),
      ),
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    "assets/images/user.png",
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 35),
                  TextFormField(
                    controller: _emailController,
                    validator: (email) {
                      if (email == null || email.isEmpty) {
                        return 'Insira um e-mail';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      prefixIcon: const Icon(Icons.email),
                      label: const Text(
                        'E-mail',
                      ),
                      hintText: 'exemplo@gmail.com',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusColor: colorPurple,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    obscureText: _passwordVisible,
                    controller: _passwordController,
                    validator: (password) {
                      if (password == null || password.isEmpty) {
                        return 'Insira uma Palavra-Passe';
                      } else if (password.length < 6) {
                        return 'A Palavra-Passe deve conter no minimo 6 caracteres';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      prefixIcon: const Icon(Icons.lock),
                      label: Text(
                        'Palavra-Passe',
                        style: TextStyle(color: colorPurple),
                      ),
                      hintText: 'Digite sua Palavra-Passe',
                      suffixIcon: IconButton(
                        onPressed: _toggleObscured,
                        icon: Icon(
                          _passwordVisible
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
                  Container(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/forgot_password');
                      },
                      child: const Text(
                        'Esqueceu a Palavra-passe?',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _errorMessage = "";
                        login().then((loggedIn) {
                          if (loggedIn) {
                            Navigator.of(context)
                                .pushReplacementNamed('/homepage');
                          }
                        });
                      }
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 25)),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(colorPurple),
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
                            _isLoading ? '' : 'Acessar',
                            style: const TextStyle(fontSize: 18),
                          ),
                          if (_isLoading)
                            const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                        ]),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/register');
                      },
                      child: const Text(
                        'Ainda não tem uma conta? Criar conta',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AnimatedContainer(
                    duration: const Duration(
                        milliseconds:
                            300), // Duração da animação, em milissegundos
                    curve: Curves.easeInOut, // Curva de animação
                    height: _errorMessage.isNotEmpty
                        ? 50
                        : 0, // Altura do contêiner dependendo se há uma mensagem de erro ou não
                    child: Visibility(
                      visible: _errorMessage.isNotEmpty,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.red,
                        ),
                        child: Text(
                          _errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
