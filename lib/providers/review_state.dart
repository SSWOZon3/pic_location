import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pic_location/services/review_service.dart';
import '../models/review_data.dart';
import '../models/user.dart';

class ReviewState extends StateNotifier<ReviewData> {
  final ReviewService _reviewService;

  ReviewState(this._reviewService)
      : super(ReviewData(
            id: '',
            description: '',
            title: '',
            latitude: 0.0,
            longitude: 0.0,
            imageUrl: ''));

  void updateReview(ReviewData newReview) {
    state = newReview;
  }

  Future<void> publishReview(double latitude, double longitude, Future<Uint8List> image,
      {required Function(ReviewData) onReviewPublished}) async {
    if (state.title.isNotEmpty && state.description.isNotEmpty) {
      final response = await _reviewService.submitReview(
          state.title, state.description, latitude, longitude);
      onReviewPublished(response);
    }
  }

  Future<void> getReviewData(String markerId) async {
    state = await _reviewService.getReviewData(markerId);
  }
}

final reviewStateProvider = StateNotifierProvider<ReviewState, ReviewData>(
    (ref) => ReviewState(ReviewService()));
