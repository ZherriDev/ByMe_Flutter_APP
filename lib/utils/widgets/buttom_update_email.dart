import "package:flutter/material.dart";

class UpdateEmail extends StatefulWidget {
  final Future<bool> Function(
    String oldEmai,
    String newEmail,
  ) updateFunction;
  final GlobalKey<FormState> formKey;
  final TextEditingController oldEmaiController;
  final TextEditingController newEmailController;

  const UpdateEmail({
    required this.updateFunction,
    required this.formKey,
    required this.oldEmaiController,
    required this.newEmailController,
  });

  @override
  State<UpdateEmail> createState() => _UpdateEmailState();
}

class _UpdateEmailState extends State<UpdateEmail> {
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
              widget.oldEmaiController.text,
              widget.newEmailController.text,
            )
                .then((succes) {
              if (succes) {
                setState(() {
                  _isLoading = false;
                });
              } else {
                setState(() {
                  _isLoading = false;
                  print('Error');
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
