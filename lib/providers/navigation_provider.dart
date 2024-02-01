import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(0);

  void changePage(int newIndex) {
    state = newIndex;
  }
}

final navigationProvider = StateNotifierProvider<NavigationNotifier, int>((ref) => NavigationNotifier());
