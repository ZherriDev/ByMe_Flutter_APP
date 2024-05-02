import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const TextStyle blackLabelStyle = TextStyle(color: Colors.black);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final backgroundColor = const Color(0xFF672D6F);
  bool _passwordVisible = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void _toggleObscured() {
    setState(() {
      _passwordVisible =!_passwordVisible;
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
                    validator: (email){
                      if(email == null || email.isEmpty){
                        return 'Insira um e-mail';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      prefixIcon: const Icon(Icons.email),
                      label: const Text('E-mail'),
                      hintText: 'exemplo@gmail.com',
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    obscureText: _passwordVisible,
                    controller: _passwordController,
                    validator: (password){
                      if (password == null || password.isEmpty){
                        return 'Insira uma Palavra-Passe';
                      }else if (password.length < 6){
                        return 'A Palavra-Passe deve conter no minimo 6 caracteres';
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      prefixIcon: const Icon(Icons.lock),
                      label: const Text('Palavra-Passe'),
                      hintText: 'Digite sua Palavra-Passe',
                      suffixIcon: IconButton(
                          onPressed: _toggleObscured,
                          icon: Icon(
                            _passwordVisible ? Icons.visibility_off : Icons.visibility,
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
                        login();
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
                    child: const Text(
                      'Acessar',
                      style: TextStyle(fontSize: 18),
                    ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    print('Logando');
  }

}

