import 'package:byme_flutter_app/utils/user/show_doctors.dart';
import 'package:flutter/material.dart';

class TransferPatient extends StatefulWidget {
  final BuildContext context;
  final int patientId;
  final PageController pageController;

  const TransferPatient(
      {Key? key,
      required this.context,
      required this.patientId,
      required this.pageController})
      : super(key: key);

  @override
  State<TransferPatient> createState() => _TransferPatientState();
}

class _TransferPatientState extends State<TransferPatient> {
  final _formKey = GlobalKey<FormState>();
  final search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void reloadModal() {
      setState(() {});
    }

    return AlertDialog(
      title: Container(
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formKey,
          child: TextFormField(
            controller: search,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[400]?.withOpacity(0.3),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () => reloadModal(),
              ),
              label: const Text('Pesquisar doutor'),
              hintText: 'Pesquise por um doutor',
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
      content: ShowDoctors(
        context: context,
        patientId: widget.patientId,
        search: search,
        pageController: widget.pageController,
      ),
    );
  }
}
