import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0), // Adiciona padding ao redor da lista
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 16.0), // Espaçamento entre os itens
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor, // Cor de fundo
              borderRadius: BorderRadius.circular(12.0), // Bordas arredondadas
            ),
            child: Container(
              padding: EdgeInsets.all(8.0), // Espaçamento interno
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2.0), // Cor e espessura da borda
                borderRadius: BorderRadius.circular(10.0), // Bordas arredondadas
                color: Colors.grey[200], // Cor de fundo do interior da borda
              ),
              child: ListTile(
                leading: Icon(Icons.lightbulb_outline), // Ícone à esquerda do texto
                title: Text('Modo Escuro'),
                onTap: () {
                  setState(() {
                    isDarkModeEnabled = !isDarkModeEnabled;
                  });
                  // Implemente aqui a lógica para ativar/desativar o modo escuro
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 16.0), // Espaçamento entre os itens
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor, // Cor de fundo
              borderRadius: BorderRadius.circular(12.0), // Bordas arredondadas
            ),
            child: Container(
              padding: EdgeInsets.all(8.0), // Espaçamento interno
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2.0), // Cor e espessura da borda
                borderRadius: BorderRadius.circular(10.0), // Bordas arredondadas
                color: Colors.grey[200], // Cor de fundo do interior da borda
              ),
              child: ListTile(
                leading: Icon(Icons.help_outline), // Ícone à esquerda do texto
                title: Text('Ajuda e Suporte'),
                onTap: () {
                  // Implemente aqui a lógica para ajuda e suporte
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor, // Cor de fundo
              borderRadius: BorderRadius.circular(12.0), // Bordas arredondadas
            ),
            child: Container(
              padding: EdgeInsets.all(8.0), // Espaçamento interno
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2.0), // Cor e espessura da borda
                borderRadius: BorderRadius.circular(10.0), // Bordas arredondadas
                color: Colors.grey[200], // Cor de fundo do interior da borda
              ),
              child: ListTile(
                leading: Icon(Icons.info_outline), // Ícone à esquerda do texto
                title: Text('Sobre'),
                onTap: () {
                  // Implemente aqui a lógica para sobre
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}