import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pic_location/providers/navigation_provider.dart';
import 'package:pic_location/providers/session_provider.dart';
import 'package:pic_location/ui/screens/login_screen.dart';
import 'config/routes.dart';
import 'ui/widgets/custom_bottom_app_bar.dart';

void main() {
  runApp(
    const ProviderScope(
      child: InitApp(),
    ),
  );
}

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

class InitApp extends ConsumerWidget {
  const InitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(sessionStateProvider);

    if (sessionState.isLoading) {
      return const MaterialApp(
        home: Scaffold(
          // TODO: Cambiar por icono de PicLocation :D
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      title: 'PicLocation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: sessionState.accessToken.isNotEmpty
          ? const HomePage()
          : const LoginScreen(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationProvider);

    return Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: routePages,
        ),
        bottomNavigationBar: CustomBottomAppBar(
          currentIndex: currentIndex,
          onTap: (index) {
            ref.read(navigationProvider.notifier).changePage(index);
          },
        ));
  }
}
