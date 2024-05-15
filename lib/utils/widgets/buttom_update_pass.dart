import "package:flutter/material.dart";

class UpdatePass extends StatefulWidget {
  final Future<bool> Function(
    String oldPassword,
    String newPasswprd,
  ) updateFunction;
  final void Function(String message) showSuccessPopUp;
  final GlobalKey<FormState> formKey;
  final TextEditingController oldpassController;
  final TextEditingController newpassController;
  final TextEditingController confirmnewpassController;

  const UpdatePass({
    required this.updateFunction,
    required this.formKey,
    required this.oldpassController,
    required this.newpassController,
    required this.confirmnewpassController,
    required this.showSuccessPopUp,
  });

  @override
  State<UpdatePass> createState() => _UpdatePassState();
}

class _UpdatePassState extends State<UpdatePass> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      child: ElevatedButton(
        onPressed: () {
          if (widget.formKey.currentState!.validate()) {
            setState(() {
              _isLoading = true;
            });
            widget
                .updateFunction(
              widget.oldpassController.text,
              widget.newpassController.text,
            )
                .then((succes) {
              if (succes) {
                setState(() {
                  _isLoading = false;
                });
                widget.showSuccessPopUp('Informações atualizadas com sucesso\n'
                    'Pra sua segurança a sua sessão será encerrada');
              } else {
                setState(() {
                  _isLoading = false;
                  print('Erro ao mudar senhas');
                });
              }
            });
          }
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor:
              MaterialStateProperty.all<Color>(const Color(0xff672D6F)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            _isLoading ? '' : 'Salvar',
            style: const TextStyle(fontSize: 18),
          ),
          if (_isLoading)
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
        ]),
      ),
    );
  }
}
