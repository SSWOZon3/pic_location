import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pic_location/providers/session_provider.dart';
import 'package:pic_location/services/review_service.dart';
import '../models/review_data.dart';

class ReviewState {
  final ReviewData reviewData;
  final bool isLoading;
  final String? errorMessage;

  ReviewState(
      {required this.reviewData, this.isLoading = false, this.errorMessage});
}

class ReviewNotifier extends StateNotifier<ReviewState> {
  final Ref ref;
  final ReviewService _reviewService;

  ReviewNotifier(this._reviewService, this.ref)
      : super(ReviewState(
            reviewData: ReviewData(
                id: '',
                description: '',
                title: '',
                latitude: 0.0,
                longitude: 0.0,
                imageUrl: '',
                publisherId: '')));

  void updateReview(ReviewData newReview) {
    state = ReviewState(reviewData: newReview, isLoading: false, errorMessage: null);
  }

  Future<void> publishReview(double latitude, double longitude,
      String imagePath, String title, String description) async {
    String accessToken = ref.read(sessionStateProvider).accessToken;

    if (title.isNotEmpty && description.isNotEmpty) {
      final response = await _reviewService.submitReview(
          title, description, latitude, longitude, imagePath, accessToken);
      state = ReviewState(reviewData: response, isLoading: false);
    }
  }

  Future<void> getReviewData(String markerId) async {
    String accessToken = ref.read(sessionStateProvider).accessToken;
    state = ReviewState(reviewData: state.reviewData, isLoading: true);
    try {
      final reviewData = await _reviewService.getReviewData(markerId, accessToken);
      state = ReviewState(reviewData: reviewData, isLoading: false);
    } catch (e) {
      state = ReviewState(reviewData: state.reviewData, isLoading: false, errorMessage: e.toString());
    }
  }
}

final reviewStateProvider = StateNotifierProvider<ReviewNotifier, ReviewState>(
        (ref) => ReviewNotifier(ReviewService(), ref));