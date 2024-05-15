import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pic_location/providers/session_provider.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;

class UserStateNotifier extends StateNotifier<User> {
  final Ref ref;

  UserStateNotifier(this.ref)
      : super(User(username: '', email: '', favorites: []));

  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/user/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "username": username,
        "password": password,
      }),
    );

    User user = User.fromJson(json.decode(response.body));
    state = user;
  }

  Future<void> getUserInfo() async {
    String accessToken = ref.read(sessionStateProvider).accessToken;
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/user/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    User user =  User.fromJson(json.decode(response.body));
    state = user;
  }

  Future<void> addReviewToFavorites(String markerId) async {
    String accessToken = ref.read(sessionStateProvider).accessToken;
    final response = await http.patch(
      Uri.parse('http://localhost:3000/api/user/favorites/$markerId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );


    User user = User.fromJson(json.decode(response.body));
    state = user;
  }

  Future<void> removeReviewFromFavorites(String markerId) async {
    String accessToken = ref.read(sessionStateProvider).accessToken;
    final response = await http.delete(
      Uri.parse('http://localhost:3000/api/user/favorites/$markerId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    User user =  User.fromJson(json.decode(response.body));
    state = user;
  }
}

final userStateProvider = StateNotifierProvider<UserStateNotifier, User>(
        (ref) => UserStateNotifier(ref));
