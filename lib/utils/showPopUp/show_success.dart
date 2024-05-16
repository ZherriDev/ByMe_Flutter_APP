import 'package:flutter/material.dart';

class SuccessPopUp extends StatefulWidget {
  const SuccessPopUp({super.key});

  @override
  State<SuccessPopUp> createState() => _SuccessPopUpState();
}

class _SuccessPopUpState extends State<SuccessPopUp> {
  void _showSuccessPopUp(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: SizedBox(
            width: 150,
            height: 150,
            child: Image.asset('assets/images/success.png'),
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
                Navigator.of(context).pushNamed('/');
                ;
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
