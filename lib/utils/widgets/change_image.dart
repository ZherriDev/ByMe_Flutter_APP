import 'package:flutter/material.dart';

class ChangeImage extends StatefulWidget {
  final void Function() pickAndUploadImage;
  const ChangeImage({
    Key? key,
    required this.pickAndUploadImage,
  }) : super(key: key);

  @override
  State<ChangeImage> createState() => _ChangeImageState();
}

class _ChangeImageState extends State<ChangeImage> {
  bool _isLoadingImage = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: [
          const Expanded(
              flex: 6,
              child: Text(
                'Mudar Imagem de Perfil',
              )),
          _isLoadingImage
              ? const Center(
                  child: SizedBox(
                    child: CircularProgressIndicator(),
                  ),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      _isLoadingImage = true;
                    });
                    widget.pickAndUploadImage();
                  },
                  icon: const Icon(Icons.add_a_photo)),
        ],
      ),
    );
  }
}
