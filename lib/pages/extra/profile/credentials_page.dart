import 'package:byme_flutter_app/utils/user/fetch_user_data.dart';
import 'package:byme_flutter_app/utils/widgets/buttom_update_email.dart';
import 'package:byme_flutter_app/utils/widgets/buttom_update_pass.dart';
import 'package:byme_flutter_app/utils/widgets/password_field.dart';
import 'package:flutter/material.dart';

class CredentialsPage extends StatefulWidget {
  final PageController pageController;
  const CredentialsPage({Key? key, required this.pageController})
      : super(key: key);

  @override
  State<CredentialsPage> createState() => _CredentialsPageState();
}

class _CredentialsPageState extends State<CredentialsPage> {
  final _oldemailController = TextEditingController();
  final _newemailController = TextEditingController();
  final _oldpassController = TextEditingController();
  final _newpassController = TextEditingController();
  final _confirmNewpassController = TextEditingController();
  final _formemailKey = GlobalKey<FormState>();
  final _formpassKey = GlobalKey<FormState>();
  final bool _isLoading = false;
  String getDate() {
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;
    int day = now.day;

    String todayDate = '$year-$month-$day';
    return todayDate;
  }

  @override
  void initState() {
    _oldpassController;
    _newpassController;
    _confirmNewpassController;
    _oldemailController;
    _newemailController;
    super.initState();
  }

  String obscureEmail(String email) {
    if (email.isEmpty || !email.contains('@')) {
      return email;
    }

    int atIndex = email.indexOf('@');
    String firstChar = email[0];
    String domain = email.substring(atIndex); // Obtém o domínio do e-mail
    String masked =
        firstChar + '*' * (atIndex - 2) + email[atIndex - 1] + domain;

    return masked;
  }

  void _showMessagePopUp(String message, bool success, String navigator) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: SizedBox(
            width: 150,
            height: 150,
            child: success
                ? Image.asset('assets/images/success.png')
                : Image.asset('assets/images/error.png'),
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
                if (success && navigator == 'password') {
                  Navigator.of(context).pushNamed('/');
                } else if (success && navigator == 'e-mail') {
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
        future: fetchUserData('all', getDate(), null, null, null),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(
              child: Text('Erro ao carregar dados'),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            widget.pageController.jumpToPage(3);
                          },
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ),
                      const Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 45),
                            Text(
                              'Credenciais da Conta',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: const Color(0xff672D6F),
                              borderRadius: BorderRadius.circular(12)),
                          child: const Text(
                            'Alterar E-mail',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title: Text(obscureEmail(
                                snapshot.data?['user']['doctor']['email'])),
                            children: [
                              SingleChildScrollView(
                                  child: Form(
                                      key: _formemailKey,
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            enabled: _isLoading == false,
                                            controller: _oldemailController,
                                            validator: (name) {
                                              if (name == null ||
                                                  name.isEmpty) {
                                                return 'Insira o e-mail antigo';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              labelText: 'E-mail antigo',
                                              filled: true,
                                              fillColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              labelStyle:
                                                  const TextStyle(fontSize: 13),
                                              prefixIcon: const Icon(Icons.email),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            enabled: _isLoading == false,
                                            controller: _newemailController,
                                            validator: (name) {
                                              if (name == null ||
                                                  name.isEmpty) {
                                                return 'Insira um E-mail';
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              labelText: 'E-mail novo',
                                              filled: true,
                                              fillColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              labelStyle:
                                                  const TextStyle(fontSize: 13),
                                              prefixIcon: const Icon(Icons.email),
                                              border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          UpdateEmail(
                                              showSuccessPopUp:
                                                  _showMessagePopUp,
                                              formKey: _formemailKey,
                                              oldEmaiController:
                                                  _oldemailController,
                                              newEmailController:
                                                  _newemailController),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      )))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(
                          thickness: 1, // Line thickness in pixels
                          color: Colors.black, // Line color
                          indent: 0, // Indentation from left edge in pixels
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: const Color(0xff672D6F),
                              borderRadius: BorderRadius.circular(12)),
                          child: const Text(
                            'Alterar Palavra-Passe',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title: const Text('*********'),
                            children: [
                              SingleChildScrollView(
                                child: Form(
                                    key: _formpassKey,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          enabled: _isLoading == false,
                                          obscureText: true,
                                          controller: _oldpassController,
                                          validator: (name) {
                                            if (name == null || name.isEmpty) {
                                              return 'Insira a Palavra-Passe antiga';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            labelText: 'Antiga Palavra-Passe',
                                            filled: true,
                                            fillColor: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            labelStyle: const TextStyle(fontSize: 13),
                                            prefixIcon: const Icon(Icons.lock),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        PasswordField(
                                          controller: _newpassController,
                                          labelText: 'Nova Palavra-Passe',
                                          enabled: _isLoading == false,
                                          validator: (password) {
                                            if (password == null ||
                                                password.isEmpty) {
                                              return 'Insira uma Palavra-passe';
                                            } else if (password.length < 8) {
                                              return 'A Palavra-Passe deve conter no minimo 8 caracteres';
                                            } else if (!RegExp(r'[a-z]')
                                                .hasMatch(password)) {
                                              return 'A Palavra-Passe deve conter pelo menos 1 letra minúscula';
                                            } else if (!RegExp(r'[A-Z]')
                                                .hasMatch(password)) {
                                              return 'A Palavra-Passe deve conter pelo menos 1 letra maiúscula';
                                            } else if (!RegExp(r'\d')
                                                .hasMatch(password)) {
                                              return 'A Palavra-Passe deve conter pelo menos 1 número';
                                            } else if (!RegExp(r'[^\w\s]')
                                                .hasMatch(password)) {
                                              return 'A Palavra-Passe deve conter pelo menos 1 símbolo';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        PasswordField(
                                          controller: _confirmNewpassController,
                                          labelText: 'Confirmar Palavra-Passe',
                                          enabled: _isLoading == false,
                                          validator: (password) {
                                            if (password == null ||
                                                password.isEmpty) {
                                              return 'Insira uma Palavra-passe';
                                            } else if (_newpassController
                                                    .text !=
                                                _confirmNewpassController
                                                    .text) {
                                              return 'As Palavras-Passe não conincidem';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        UpdatePass(
                                          showSuccessPopUp: _showMessagePopUp,
                                          formKey: _formpassKey,
                                          oldpassController: _oldpassController,
                                          newpassController: _newpassController,
                                          confirmnewpassController:
                                              _confirmNewpassController,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ))
              ],
            );
          }
        });
  }
}
