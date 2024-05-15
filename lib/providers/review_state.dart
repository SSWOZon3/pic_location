import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pic_location/providers/session_provider.dart';
import 'package:pic_location/services/review_service.dart';
import '../models/review_data.dart';

class ReviewState extends StateNotifier<ReviewData> {
  final Ref ref;
  final ReviewService _reviewService;

  ReviewState(this._reviewService, this.ref)
      : super(ReviewData(
            id: '',
            description: '',
            title: '',
            latitude: 0.0,
            longitude: 0.0,
            imageUrl: '',
            publisherId: ''));

  void updateReview(ReviewData newReview) {
    state = newReview;
  }

  Future<void> publishReview(double latitude, double longitude, Future<Uint8List> image,
      {required Function(ReviewData) onReviewPublished}) async {
    String accessToken = ref.read(sessionStateProvider).accessToken;

    if (state.title.isNotEmpty && state.description.isNotEmpty) {
      final response = await _reviewService.submitReview(
          state.title, state.description, latitude, longitude, accessToken);
      onReviewPublished(response);
    }
  }

  Future<void> getReviewData(String markerId) async {
    String accessToken = ref.read(sessionStateProvider).accessToken;
    state = await _reviewService.getReviewData(markerId, accessToken);
  }
}

final reviewStateProvider = StateNotifierProvider<ReviewState, ReviewData>(
    (ref) => ReviewState(ReviewService(), ref));
