import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/review_data.dart';
import 'package:path/path.dart';

class ReviewService {
  Future<ReviewData> submitReview(String title, String description,
      double latitude, double longitude, String imagePath, String accessToken) async {

    final request = http.MultipartRequest('POST', Uri.parse('http://localhost:3000/api/review'))
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..fields['title'] = title
      ..fields['description'] = description
      ..fields['latitude'] = latitude.toString()
      ..fields['longitude'] = longitude.toString()
      ..files.add(await http.MultipartFile.fromPath(
        'image',
        imagePath,
        contentType: MediaType('image', getImageType(imagePath)),
      ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if(response.statusCode != 200) {
      throw Exception('Error uploading image');
    }
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

  String getImageType(String path) {
    final fileExtension = extension(path).toLowerCase();
    switch (fileExtension) {
      case '.jpg':
      case '.jpeg':
        return 'jpeg';
      case '.png':
        return 'png';
      case '.webp':
        return 'webp';
      default:
        return 'jpeg';
    }
  }
}
