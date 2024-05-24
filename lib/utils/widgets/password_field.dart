import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool enabled;
  final FormFieldValidator<String>? validator;

  const PasswordField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.enabled,
    this.validator,
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _passwordVisible = true;

  void _toggleObscured() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      obscureText: _passwordVisible,
      controller: widget.controller,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.labelText,
        filled: true,
        fillColor: Theme.of(context).colorScheme.secondary,
        labelStyle: const TextStyle(fontSize: 13),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          onPressed: _toggleObscured,
          icon: Icon(
            _passwordVisible ? Icons.visibility_off : Icons.visibility,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
