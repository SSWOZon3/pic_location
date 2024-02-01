import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/map_state.dart';
import '../../models/review_data.dart';
import '../../providers/review_state.dart';

class AddLocationDetailsScreen extends ConsumerStatefulWidget {
  final LatLng location;

  const AddLocationDetailsScreen({Key? key, required this.location})
      : super(key: key);

  @override
  _AddLocationDetailsScreenState createState() =>
      _AddLocationDetailsScreenState();
}

class _AddLocationDetailsScreenState
    extends ConsumerState<AddLocationDetailsScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  @override
  Widget build(BuildContext context) {
    final reviewData = ref.watch(reviewStateProvider);

    void publishReview() {
      Future<Uint8List> image = _selectedImage!.readAsBytes();

      ref
          .read(reviewStateProvider.notifier)
          .publishReview(widget.location.latitude, widget.location.longitude, image,
              onReviewPublished: (ReviewData updatedReviewData) {
        ref
            .read(mapStateProvider.notifier)
            .updateMarker(widget.location, reviewData.id);
      });
      Navigator.pop(context);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MaterialButton(
              child: Text('Upload Image'),
              onPressed: () async {
                final image = await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  _selectedImage = image;
                }
              }
          ),
          TextField(
            onChanged: (value) => ref
                .read(reviewStateProvider.notifier)
                .updateReview(reviewData.copyWith(title: value)),
            decoration: const InputDecoration(
              labelText: 'Título de la reseña',
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            onChanged: (value) => ref
                .read(reviewStateProvider.notifier)
                .updateReview(reviewData.copyWith(description: value)),
            decoration: const InputDecoration(
              labelText: 'Descripción de la reseña',
              border: OutlineInputBorder(),
            ),
            maxLines: 6,
          ),
          ElevatedButton(
            onPressed: publishReview,
            child: const Text('Publicar'),
          ),
        ],
      ),
    );
  }
}
