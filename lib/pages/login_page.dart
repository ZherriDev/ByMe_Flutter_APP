import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:byme_flutter_app/utils/get_session_data.dart';
import 'package:byme_flutter_app/utils/write_token.dart';

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
    Map<String, dynamic> deviceInfo = await getDeviceInfo();

    // Extrai os valores do mapa e armazena-os em variáveis
    String deviceModel = deviceInfo['deviceModel'];
    String osName = deviceInfo['osName'];
    String ipAddress = deviceInfo['ipAddress'];
    bool successLogin = false;

    const Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    var url = Uri.parse('https://api-py-byme.onrender.com/auth/login');
    var body = {
      "email": _emailController.text,
      "password": _passwordController.text,
      "ip_address": ipAddress,
      "device": deviceModel,
      "operational_system": osName,
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
            String token = jsonDecode(response.body)['token'];
            int doctorId = jsonDecode(response.body)['doctor_id'];
            writeToken(token, doctorId.toString());
            setState(() {
              _errorMessage = '';
              successLogin = true;
            });
          } catch (error) {
            setState(() {
              _errorMessage = 'Erro ao salvar JWT. Error: $error';
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
    } catch (error) {
      setState(() {
        successLogin = false;
        _errorMessage =
            'Erro de Conexão. Verifique sua conexão com a internet.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
    return successLogin;
  }

  void _toggleObscured() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  enabled: _isLoading == false,
                  controller: _emailController,
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return 'Insira o seu e-mail';
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
                const SizedBox(height: 15),
                TextFormField(
                  enabled: _isLoading == false,
                  obscureText: _passwordVisible,
                  controller: _passwordController,
                  validator: (password) {
                    if (password == null || password.isEmpty) {
                      return 'Insira a sua palavra-passe';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    prefixIcon: const Icon(Icons.lock),
                    label: const Text('Palavra-passe'),
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
                      Navigator.of(context).pushNamed('/forgot_password');
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
                          Navigator.of(context).pushReplacementNamed('/homepage');
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
                      Navigator.of(context).pushNamed('/register');
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
                Visibility(
                  visible: _errorMessage.isNotEmpty,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.red),
                    child: Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
