import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pic_location/providers/user_provider.dart';
import '../../providers/review_state.dart';

class CreateReviewScreen extends ConsumerStatefulWidget {
  final String markerId;
  final ScrollController scrollController;

  const CreateReviewScreen(
      {Key? key, required this.markerId, required this.scrollController})
      : super(key: key);

  @override
  CreateReviewScreenState createState() => CreateReviewScreenState();
}

class CreateReviewScreenState extends ConsumerState<CreateReviewScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  XFile? _image;
  Uint8List? _imageInBytes;

  @override
  void initState() {
    super.initState();

    titleController.text = 'Titulo de la reseña...';
    descriptionController.text = 'Detalla cómo has hecho la foto...';
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageInBytes = await pickedFile.readAsBytes();

      setState(() {
        _image = pickedFile;
        _imageInBytes = imageInBytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final reviewData = ref.watch(reviewStateProvider);
    final userData = ref.watch(userStateProvider);
    final userProvider = ref.read(userStateProvider.notifier);
    final screenSize = MediaQuery.of(context).size;

    return Stack(children: [
      SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            GestureDetector(
              onTap: _pickImage,
              child: _image != null
                  ? Container(
                      // TODO: poner todo con porcentajes
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Image.file(File(_image!.path), fit: BoxFit.cover))
                  : Container( // TODO: poner todo con porcentajes
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.photo_camera,
                              size: 50, color: Colors.grey),
                          Text('Selecciona una foto'),
                        ],
                      ),
                    ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(screenSize.width * 0.03),
                  child: TextField(
                    controller: titleController,
                    style: TextStyle(
                        fontSize: screenSize.width * 0.06,
                        fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(screenSize.width * 0.03, 0,
                      screenSize.width * 0.03, screenSize.width * 0.03),
                  child: TextField(
                    controller: descriptionController,
                    style: TextStyle(
                      fontSize: screenSize.width * 0.05,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
        alignment: Alignment.bottomCenter,
        // TODO: poner esto en porcentaje
        padding: const EdgeInsets.only(bottom: 26.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(elevation: 2),
          onPressed: () {
            // TODO: Conectar esto con el back
          },
          child: Text('Publicar'),
        ),
      ),
    ]);
  }
}
