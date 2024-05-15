import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pic_location/models/review_data.dart';

class MapService {
  Future<List<ReviewData>> fetchLocationsWithinArea(LatLngBounds bounds, String accessToken) async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/review/area?'
          'topRightLat=${bounds.northeast.latitude}&'
          'topRightLng=${bounds.northeast.longitude}&'
          'bottomLeftLat=${bounds.southwest.latitude}&'
          'bottomLeftLng=${bounds.southwest.longitude}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      List<ReviewData> reviewDataList =
          jsonList.map((json) => ReviewData.fromJson(json)).toList();
      return reviewDataList;
    } else {
      throw Exception('Failed to fetch locations');
    }
  }
}
