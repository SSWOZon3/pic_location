import 'package:pic_location/models/review_data.dart';

class User {
  final String username;
  final String email;
  final List<ReviewData> favorites;

  User({
    required this.username,
    required this.email,
    required this.favorites,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var favoriteList = json['favorites'] as List;
    List<ReviewData> favoriteObjects =
        favoriteList.map((item) => ReviewData.fromJson(item)).toList();

    return User(
      username: json['username'],
      email: json['email'],
      favorites: favoriteObjects,
    );
  }

  User copyWith({
    String? username,
    String? email,
    List<ReviewData>? favorites,
  }) {
    return User(
      username: username ?? this.username,
      email: email ?? this.email,
      favorites: favorites ?? this.favorites,
    );
  }

}
