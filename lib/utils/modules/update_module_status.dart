import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:byme_flutter_app/utils/token/read_token.dart';

class UpdateModuleStatus extends StatefulWidget {
  final BuildContext context;
  final int moduleId;
  final Map<String, dynamic> module;
  final Function() reloadPage;

  const UpdateModuleStatus(
      {Key? key,
      required this.context,
      required this.moduleId,
      required this.module,
      required this.reloadPage})
      : super(key: key);

  @override
  State<UpdateModuleStatus> createState() => _UpdateModuleStatusState();
}

class _UpdateModuleStatusState extends State<UpdateModuleStatus> {
  bool isLoading = false;

  final List<String> _status = ['In Progress', 'Paused', 'Finished'];

  Future<bool?> updateModuleStatus(moduleId, status) async {
    Map<String, dynamic>? userStorage = await readToken();
    String token = userStorage?['token'];

    var url = Uri.parse(
        'https://api-py-byme.onrender.com/module/update_module_status');

    var body = {"module_id": moduleId, "status": status};

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
          return false;
        case 429:
          return false;
        case 500:
          return false;
      }
    } catch (error) {
      throw '$error';
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    String status = widget.module['status'];

    return AlertDialog(
        title: const Text(
          'Mudar para qual estado?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Stack(
          children: [
            Form(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.tertiary,
                  prefixIcon: const Icon(Icons.info),
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
                      status == 'In Progress'
                          ? 'Em progresso'
                          : status == 'Paused'
                              ? 'Pausado'
                              : 'Finished',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    status = newValue!;
                    isLoading = true;
                  });
                  updateModuleStatus(widget.moduleId, status).then((success) {
                    if (success == true) {
                      Navigator.of(context).pop();
                      widget.reloadPage();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text('Estado do módulo atualizado com sucesso.'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ));
                    } else {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Não foi possível atualizar o estado do módulo.'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ));
                    }
                  });
                },
                validator: (status) {
                  if (status == null) {
                    return 'Por favor, selecione o estado do módulo';
                  }
                  return null;
                },
              ),
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.grey.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ));
  }
}
