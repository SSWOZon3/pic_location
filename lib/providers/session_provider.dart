import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pic_location/providers/user_provider.dart';
import '../main.dart';

class SessionState {
  final String accessToken;
  final bool isLoading;

  SessionState({this.accessToken = '', this.isLoading = true});
}

class SessionStateNotifier extends StateNotifier<SessionState> {
  final Ref ref;

  SessionStateNotifier(this.ref) : super(SessionState()) {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final storage = ref.read(secureStorageProvider);
    final token = await storage.read(key: 'accessToken');
    state = SessionState(accessToken: token ?? '', isLoading: false);
    if(token != null) {
      ref.read(userStateProvider.notifier).getUserInfo();
    }
  }

  void login(String token) {
    state = SessionState(accessToken: token, isLoading: false);
  }

  void logout() {
    ref.read(secureStorageProvider).delete(key: 'accessToken');
    state = SessionState(accessToken: '', isLoading: false);
  }
}

final sessionStateProvider = StateNotifierProvider<SessionStateNotifier, SessionState>((ref) {
  return SessionStateNotifier(ref);
});
