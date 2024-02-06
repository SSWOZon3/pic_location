import 'package:pic_location/models/user.dart';

class ReviewData {
  final String id;
  final String description;
  final String title;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final String publisherId;

  ReviewData(
      {required this.id,
      required this.description,
      required this.title,
      required this.latitude,
      required this.longitude,
      required this.imageUrl,
      required this.publisherId});

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      id: json['_id'],
      description: json['description'],
      title: json['title'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      imageUrl: json['imageUrl'],
      publisherId: json['publisherId'],
    );
  }

  ReviewData copyWith({
    String? id,
    String? description,
    String? title,
    double? latitude,
    double? longitude,
    String? imageUrl,
    String? publisherId,
  }) {
    return ReviewData(
      id: id ?? this.id,
      description: description ?? this.description,
      title: title ?? this.title,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageUrl: imageUrl ?? this.imageUrl,
      publisherId: publisherId ?? this.publisherId,
    );
  }
}
