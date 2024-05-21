import 'package:byme_flutter_app/utils/token/read_token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DeleteModule extends StatefulWidget {
  final BuildContext context;
  final int moduleId;
  final PageController pageController;

  const DeleteModule(
      {Key? key,
      required this.context,
      required this.moduleId,
      required this.pageController})
      : super(key: key);

  @override
  State<DeleteModule> createState() => _DeleteModuleState();
}

class _DeleteModuleState extends State<DeleteModule> {
  bool isLoading = false;

  Future<bool?> deleteModule(int moduleId) async {
    final userStorage = await readToken();
    String token = userStorage?['token'];

    var url =
        Uri.parse('https://api-py-byme.onrender.com/module/delete_module');

    var body = {
      "module_id": moduleId,
    };

    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response =
          await http.delete(url, body: jsonEncode(body), headers: header);

      switch (response.statusCode) {
        case 200:
          return true;
        case 400:
          print('Dados Incorretos');
          return false;
        case 401:
          print('Token Inválido');
          return false;
        case 500:
          print('Erro no servidor');
          return false;
      }
    } catch (error) {
      print('Error: $error');
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
      title: SizedBox(
        width: 150,
        height: 150,
        child: Image.asset('assets/images/warning.png'),
      ),
      content: Text(
        'Você não poderá voltar atrás com esta ação. Tem certeza que deseja excluir este módulo?',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(widget.context).pop();
          },
        ),
        TextButton(
          child: isLoading
              ? CircularProgressIndicator(
                  strokeWidth: 2,
                )
              : const Text('Excluir'),
          onPressed: () {
            setState(() {
              isLoading = true;
            });
            deleteModule(widget.moduleId).then((success) {
              if (success == true) {
                Navigator.of(widget.context).pop();
                widget.pageController.jumpToPage(6);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Módulo excluído com sucesso.'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ));
              } else {
                Navigator.of(widget.context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Não foi possível excluir o módulo.'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                ));
              }
            });
          },
        ),
      ],
    );
  }
}
