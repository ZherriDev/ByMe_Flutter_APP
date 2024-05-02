import 'package:flutter/material.dart';

void main() {
  runApp(RegisterApp());
}

class RegisterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Registro de Usuário',
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  late final _usernameController = TextEditingController();
  late final _emailController = TextEditingController();
  late final _passwordController = TextEditingController();
  late final _confirmPasswordController = TextEditingController();
  String? _selectedSpecialty;
  bool _acceptTerms = false;

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

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildBox(
                labelText: 'Nome de Usuário',
                controller: _usernameController,
                icon: Icons.person,
              ),
              const SizedBox(height: 10.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Especialidade',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                value: _selectedSpecialty,
                items: _specialties.map((String specialty) {
                  return DropdownMenuItem<String>(
                    value: specialty,
                    child: Text(specialty),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedSpecialty = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor, selecione uma especialidade';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              _buildBox(
                labelText: 'E-mail',
                controller: _emailController,
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o e-mail';
                  } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Por favor, insira um e-mail válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10.0),
              _buildBox(
                labelText: 'Senha',
                controller: _passwordController,
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 10.0),
              _buildBox(
                labelText: 'Confirmar Senha',
                controller: _confirmPasswordController,
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Checkbox(
                    value: _acceptTerms,
                    onChanged: (value) {
                      setState(() {
                        _acceptTerms = value!;
                      });
                    },
                  ),
                  const Text('Aceitar Termos e Condições'),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_acceptTerms) {
                      if (_formKey.currentState!.validate()) {
                        if (_passwordController.text == _confirmPasswordController.text) {
                          _formKey.currentState!.save();
                          registerUser(
                            _usernameController.text,
                            _emailController.text,
                            _passwordController.text,
                            _selectedSpecialty ?? '',
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Erro'),
                                content: const Text('As senhas não coincidem.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Erro'),
                            content: const Text('Por favor, aceite os termos e condições.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    backgroundColor: const Color(0xff672D6F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text('Registrar', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBox({
    required String labelText,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          prefixIcon: Icon(icon),
        ),
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
      ),
    );
  }
}

void registerUser(String username, String email, String password, String especialidade) {
  // Implemente sua lógica de registro de usuário aqui
}
