import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateModule extends StatefulWidget {
  final BuildContext context;
  final int moduleId;
  final Map<String, dynamic> module;
  final Function() reloadPage;

  const UpdateModule(
      {Key? key,
      required this.context,
      required this.moduleId,
      required this.module,
      required this.reloadPage})
      : super(key: key);

  @override
  State<UpdateModule> createState() => _UpdateModuleState();
}

class _UpdateModuleState extends State<UpdateModule> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController episode;
  late String module;
  bool isLoading = false;
  String message = '';

  final List<String> _module = [
    'Módulo A',
    'Módulo B',
    'Módulo C',
    'Módulo D',
    'Módulo E'
  ];

  @override
  void initState() {
    super.initState();
    episode = TextEditingController(text: widget.module['episode']);
    module = 'Módulo ${widget.module['module']}';
  }

  Future<bool?> updateModule(moduleId, episode, module) async {
    Map<String, dynamic>? userStorage = await readToken();
    String token = userStorage?['token'];

    module = module!.substring(module!.length - 1);

    var url =
        Uri.parse('https://api-py-byme.onrender.com/module/update_module');
    var body = {"module_id": moduleId, "episode": episode, "module": module};
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.patch(
        url,
        body: jsonEncode(body),
        headers: header,
      );
      switch (response.statusCode) {
        case 200:
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
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
            color: const Color(0xff672D6F), borderRadius: BorderRadius.circular(10)),
        child: const Text(
          'Editar Módulo',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 240,
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
                  prefixIcon: const Icon(Icons.abc),
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
                      style: const TextStyle(
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
                child: const Text(
                  'Cancelar',
                  style: TextStyle(fontSize: 18),
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
                    updateModule(widget.moduleId, episode.text, module)
                        .then((success) {
                      if (success == true) {
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
                    isLoading ? '' : 'Salvar',
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
