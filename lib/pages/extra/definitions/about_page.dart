import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  final PageController pageController;
  const AboutPage({Key? key, required this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      pageController.jumpToPage(4);
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 45),
                      Text(
                        'Sobre',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 40,
            child: Text(
              'O objetivo da aplicação é auxiliar o trabalho de '
              'médicos, permitindo-os que gerenciem seus '
              'pacientes e consultas. Ela oferece uma '
              'interface intuitiva e funcionalidades que '
              'facilitam o dia a dia do profissional, ao otimizar '
              'seu tempo e aprimorar a qualidade do atendimento.\n\n'
              'A ByMe - Information Technology, Lda. é uma '
              'empresa especializada em soluções '
              'tecnológicas avançadas. Nosso proposito é '
              'transformar processos complexos em tarefas '
              'simples, permitindo que nossos clientes, '
              'especialmente no setor de saúde, possam manter o foco '
              'no que é realmente importante. Valorizamos '
              'inovação, qualidade, ética e a satisfação dos '
              'nossos clientes.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
