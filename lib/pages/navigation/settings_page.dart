import 'package:byme_flutter_app/app_controller.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final PageController pageController;

  const SettingsPage({Key? key, required this.pageController}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        buildSettingItem(
          context,
          icon: Icons.lightbulb_outline,
          title: AppController.instance.isDarkTheme ? 'Modo Claro' : 'Modo Escuro',
          onTap: () {
            AppController.instance.changeTheme();
          },
        ),
        buildSettingItem(
          context,
          icon: Icons.help_outline,
          title: 'Ajuda e Suporte',
          onTap: () {
            // Implemente aqui a lógica para ajuda e suporte
          },
        ),
        buildSettingItem(
          context,
          icon: Icons.info_outline,
          title: 'Sobre',
          onTap: () {
            // Implemente aqui a lógica para sobre
          },
        ),
      ],
    );
  }

  Widget buildSettingItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[200],
        ),
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          onTap: onTap,
        ),
      ),
    );
  }
}
