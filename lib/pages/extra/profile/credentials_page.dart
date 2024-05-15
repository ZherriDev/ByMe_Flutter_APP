import 'package:byme_flutter_app/utils/user/fetch_user_data.dart';
import 'package:byme_flutter_app/utils/user/update_pass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CredentialsPage extends StatefulWidget {
  final PageController pageController;
  const CredentialsPage({Key? key, required this.pageController})
      : super(key: key);

  @override
  State<CredentialsPage> createState() => _CredentialsPageState();
}

class _CredentialsPageState extends State<CredentialsPage> {
  final _oldpassController = TextEditingController();
  final _newpassController = TextEditingController();
  final _confirmNewpassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
        future: fetchUserData(context, 'all', getDate(), null, null, null),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text('Erro ao carregar dados'),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 30),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          widget.pageController.jumpToPage(3);
                        },
                        icon: Icon(Icons.arrow_back),
                      ),
                      SizedBox(
                        width: 70,
                      ),
                      Text(
                        'Palavra-Passe',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Color(0xff672D6F),
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(
                              'Alterar E-mail',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          ExpansionTile(
                            title:
                                Text(snapshot.data?['user']['doctor']['email']),
                                children: [],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          ExpansionTile(
                            title: Text('Alterar Palavra-Passe'),
                            children: [
                              TextFormField(
                                enabled: _isLoading == false,
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
                                  fillColor: Colors.grey[200],
                                  labelStyle: TextStyle(fontSize: 13),
                                  prefixIcon: Icon(Icons.lock),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                enabled: _isLoading == false,
                                controller: _newpassController,
                                validator: (password) {
                                  if (password == null || password.isEmpty) {
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
                                decoration: InputDecoration(
                                  labelText: 'Nova Palavra-Passe',
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  labelStyle: TextStyle(fontSize: 13),
                                  prefixIcon: Icon(Icons.lock),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              TextFormField(
                                enabled: _isLoading == false,
                                controller: _confirmNewpassController,
                                validator: (password) {
                                  if (password == null || password.isEmpty) {
                                    return 'Insira uma Palavra-passe';
                                  } else if (password.length < 8) {
                                    return 'A Palavra-Passe deve conter no minimo 8 caracteres';
                                  } else if (!RegExp(r'[a-z]')
                                      .hasMatch(password)) {
                                    return 'A Palavra-Passe deve conter pelo menos 1  letra minúscula';
                                  } else if (!RegExp(r'[A-Z]')
                                      .hasMatch(password)) {
                                    return 'A Palavra-Passe deve conter pelo menos 1 letra maiúscula';
                                  } else if (!RegExp(r'\d')
                                      .hasMatch(password)) {
                                    return 'A Palavra-Passe deve conter pelo menos 1 número';
                                  } else if (!RegExp(r'[^\w\s]')
                                      .hasMatch(password)) {
                                    return 'A Palavra-Passe deve conter pelo menos 1 símbolo';
                                  } else if (_newpassController.text !=
                                      _confirmNewpassController) {
                                    return 'As Palavras-Passe não coincidem';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Confirmar nova Palavra-Passe',
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  labelStyle: TextStyle(fontSize: 13),
                                  prefixIcon: Icon(Icons.lock),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
              ],
            );
          }
        });
  }
}
