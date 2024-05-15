import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/review_data.dart';

class ReviewService {
  Future<ReviewData> submitReview(String title, String description,
      double latitude, double longitude, String accessToken) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/review'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        "title": title,
        "description": description,
        "latitude": latitude,
        "longitude": longitude,
      }),
    );
    return ReviewData.fromJson(json.decode(response.body));
  }

  Future<ReviewData> getReviewData(String markerId, String accessToken) async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/review/$markerId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    return ReviewData.fromJson(json.decode(response.body));
  }
}
