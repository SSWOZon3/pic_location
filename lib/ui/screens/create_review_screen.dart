import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pic_location/providers/user_provider.dart';
import '../../models/review_data.dart';
import '../../providers/map_state.dart';
import '../../providers/review_state.dart';

class CreateReviewScreen extends ConsumerStatefulWidget {
  final String markerId;
  final ScrollController scrollController;
  final LatLng location;

  const CreateReviewScreen(
      {Key? key, required this.markerId, required this.scrollController, required this.location})
      : super(key: key);

  @override
  CreateReviewScreenState createState() => CreateReviewScreenState();
}

class CreateReviewScreenState extends ConsumerState<CreateReviewScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  XFile? _selectedImage;

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
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final reviewState = ref.watch(reviewStateProvider);
    final userData = ref.watch(userStateProvider);
    final screenSize = MediaQuery.of(context).size;

    void publishReview() {
      if (_selectedImage == null) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Selecciona una imagen'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }
      ref.read(reviewStateProvider.notifier).publishReview(
        widget.location.latitude,
        widget.location.longitude,
        _selectedImage!.path,
        titleController.text,
        descriptionController.text,
      );
    }

    ref.listen<ReviewState>(reviewStateProvider, (previous, next) {
      if (previous?.reviewData.id != next.reviewData.id && next.reviewData.id.isNotEmpty){
        ref.read(mapStateProvider.notifier).updateMarker(widget.location, next.reviewData.id);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review published successfully!')),
        );
      }
    });

    return Stack(
      children: [
        SingleChildScrollView(
          controller: widget.scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: _selectedImage != null
                    ? Container(
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
                    child: Image.file(File(_selectedImage!.path), fit: BoxFit.cover))
                    : Container(
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
        if (reviewState.isLoading)
          const Center(child: CircularProgressIndicator()),
        if (reviewState.errorMessage != null)
          Center(
            child: AlertDialog(
              title: const Text('Error'),
              content: Text(reviewState.errorMessage!),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    ref.read(reviewStateProvider.notifier).updateReview(ReviewData(
                      id: '',
                      description: '',
                      title: '',
                      latitude: 0.0,
                      longitude: 0.0,
                      imageUrl: '',
                      publisherId: '',
                    )); // Reset the error state
                  },
                ),
              ],
            ),
          ),
        Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 26.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(elevation: 2),
            onPressed: publishReview,
            child: const Text('Publicar'),
          ),
        ),
      ],
    );
  }
}
