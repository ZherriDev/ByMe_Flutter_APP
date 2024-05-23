import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddModule extends StatefulWidget {
  final BuildContext context;
  final Function() reloadPage;
  final int patientId;

  const AddModule(
      {Key? key,
      required this.context,
      required this.reloadPage,
      required this.patientId})
      : super(key: key);

  @override
  State<AddModule> createState() => _AddModuleState();
}

class _AddModuleState extends State<AddModule> {
  final _formKey = GlobalKey<FormState>();
  final episode = TextEditingController();
  String module = "Módulo A";
  String status = "Em progresso";
  bool isLoading = false;
  String message = '';

  final List<String> _module = [
    'Módulo A',
    'Módulo B',
    'Módulo C',
    'Módulo D',
    'Módulo E'
  ];
  final List<String> _status = ['Em progresso', 'Pausado', 'Terminado'];

  Future<bool?> addModule(patientId, episode, module, status) async {
    Map<String, dynamic>? userStorage = await readToken();
    String token = userStorage?['token'];

    module = module!.substring(module!.length - 1);

    if (status == 'Em progresso') {
      status = 'In Progress';
    } else if (status == 'Pausado') {
      status = 'Paused';
    } else if (status == 'Terminado') {
      status = 'Finished';
    }

    var url =
        Uri.parse('https://api-py-byme.onrender.com/module/insert_module');
    var body = {
      'patient_id': patientId,
      'episode': episode,
      'module': module,
      'status': status
    };
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.post(
        url,
        body: jsonEncode(body),
        headers: header,
      );
      switch (response.statusCode) {
        case 201:
          return true;
        case 400:
          setState(() {
            message =
                'Os tipos de dados introduzidos não correspondem aos que foram pedidos.';
          });
          return false;
        case 429:
          setState(() {
            message = 'Muitas requisições, tente novamente em 1 minuto.';
          });
          return false;
        case 500:
          setState(() {
            message = 'Algo correu mal.';
          });
          return false;
      }
    } catch (error) {
      setState(() {
        message = 'Erro de conexão. Verifique sua conexão com a internet.';
      });
      return false;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
            color: Color(0xff672D6F), borderRadius: BorderRadius.circular(10)),
        child: Text(
          'Novo Módulo',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: 315,
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                height: 5,
              ),
              TextFormField(
                enabled: isLoading == false,
                controller: episode,
                validator: (episode) {
                  if (episode == null || episode.isEmpty) {
                    return 'Insira o episódio do módulo';
                  }
                  return null;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                minLines: 5,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.tertiary,
                  prefixIcon: const Icon(Icons.library_books),
                  label: const Text('Episódio'),
                  hintText: 'Episódio do módulo',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Container(
                height: 10,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.tertiary,
                  prefixIcon: Icon(Icons.abc),
                  label: const Text('Módulo'),
                  hintText: 'Escolha o módulo',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: module,
                items: _module.map((String module) {
                  return DropdownMenuItem<String>(
                    value: module,
                    child: Text(
                      module,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    module = newValue!;
                  });
                },
                validator: (module) {
                  if (module == null) {
                    return 'Por favor, selecione o módulo';
                  }
                  return null;
                },
              ),
              Container(
                height: 10,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.tertiary,
                  prefixIcon: Icon(Icons.info),
                  label: const Text('Estado'),
                  hintText: 'Estado do módulo',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: status,
                items: _status.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(
                      status,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    status = newValue!;
                  });
                },
                validator: (status) {
                  if (status == null) {
                    return 'Por favor, selecione o estado do módulo';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(widget.context).pop();
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 25)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xff672D6F)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                child: Text(
                  'Cancelar',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            Container(
              width: 5,
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                      message = "";
                    });
                    addModule(widget.patientId, episode.text, module, status)
                        .then((success) {
                      if (success == true) {
                        _formKey.currentState!.reset();
                        Navigator.of(widget.context).pop();
                        widget.reloadPage();
                      }
                    });
                  }
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 25)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xff672D6F)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    isLoading ? '' : 'Adicionar',
                    style: const TextStyle(fontSize: 18),
                  ),
                  if (isLoading)
                    const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                ]),
              ),
            ),
          ],
        ),
        Container(
          height: 10,
        ),
        Visibility(
          visible: message.isNotEmpty,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: Colors.red),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
