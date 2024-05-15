import 'package:flutter/material.dart';

class ModulePage extends StatefulWidget {
  final int moduleId;
  final PageController pageController;

  const ModulePage(
      {Key? key, required this.moduleId, required this.pageController})
      : super(key: key);

  @override
  State<ModulePage> createState() => _ModulePageState();
}

class _ModulePageState extends State<ModulePage> {
  @override
  Widget build(BuildContext context) {
    return Text('${widget.moduleId}');
  }
}
