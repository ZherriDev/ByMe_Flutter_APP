import 'package:flutter/material.dart';

class SaveButton extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController birthdateController;
  final TextEditingController addressController;


  final String speciality;
  final String currentImage;
  final String? sex;
  final Future<bool> Function(
    String name,
    int phone,
    String birthdate,
    String address,
    String speciality,
    String currentImage,
    String? sex,
  ) updateData;
  final void Function(String message) showSuccessPopUp;
  final String buttonText;

  const SaveButton({
    Key? key,
  
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.birthdateController,
    required this.addressController,
    required this.speciality,
    required this.currentImage,
    required this.sex,
    required this.updateData,
    required this.showSuccessPopUp,
    required this.buttonText,
  }) : super(key: key);

  @override
  State<SaveButton> createState() => _SaveButtonState();
}


class _SaveButtonState extends State<SaveButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 30, left: 20, right: 20),
      width: 400,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _isLoading = true;
          });

          if (widget.formKey.currentState!.validate()) {
            int phoneValue = int.parse(widget.phoneController.text);

            widget
                .updateData(
              widget.nameController.text,
              phoneValue,
              widget.birthdateController.text,
              widget.addressController.text,
              widget.speciality,
              widget.currentImage,
              widget.sex,
            )
                .then((success) {
              setState(() {
                _isLoading = false;
              });
              if (success) {
                widget.showSuccessPopUp('Informações Atualizadas com sucesso!');
              } else {
                throw 'error';
              }
            });
          } else {
            setState(() {
              _isLoading = false;
            });
          }
        },
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 15, horizontal: 25)),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor:
              MaterialStateProperty.all<Color>(const Color(0xff672D6F)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isLoading ? '' : widget.buttonText,
              style: const TextStyle(fontSize: 18),
            ),
            if (_isLoading)
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
          ],
        ),
      ),
    );
  }
}
