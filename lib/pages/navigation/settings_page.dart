import 'package:byme_flutter_app/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  final PageController pageController;

  const SettingsPage({Key? key, required this.pageController})
      : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void helpAndSupport() async {
    final Uri url = Uri.parse('mailto:helpdesk@byme.pt');
    launchUrl(url).onError(
      (error, stackTrace) {
        throw "Url is not valid!";
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
      child: Consumer<UIProvider>(
        builder: (context, UIProvider notifier, child) {
          return Column(
            children: [
              GestureDetector(
                onTap: () => notifier.changeTheme(),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  width: MediaQuery.of(context).size.width - 40,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                          notifier.isDark ? Icons.light_mode : Icons.dark_mode),
                      Text(
                        notifier.isDark ? 'Modo Claro' : 'Modo Escuro',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 10,
              ),
              GestureDetector(
                onTap: helpAndSupport,
                child: Container(
                  padding: const EdgeInsets.all(30),
                  width: MediaQuery.of(context).size.width - 40,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.support_agent),
                      Text(
                        'Ajuda e Suporte',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 10,
              ),
              GestureDetector(
                onTap: () => widget.pageController.jumpToPage(10),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  width: MediaQuery.of(context).size.width - 40,
                  height: 80,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.info),
                      Text(
                        'Sobre',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
