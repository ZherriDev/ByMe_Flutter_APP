import 'package:flutter/material.dart';

class bottomNavigator extends StatefulWidget {
  const bottomNavigator({super.key});

  @override
  State<bottomNavigator> createState() => _bottomNavigatorState();
}

class _bottomNavigatorState extends State<bottomNavigator> {
  int _currentIndex = 0;
  List<Widget> body = const [Icon(Icons.home), Icon(Icons.settings)];
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

