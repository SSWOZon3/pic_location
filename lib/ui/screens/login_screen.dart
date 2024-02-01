import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pic_location/providers/session_provider.dart';
import '../../main.dart';
import '../../providers/user_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storage = ref.read(secureStorageProvider);

    ref.listen(userStateProvider, (_, currentState) {
      String accessToken = currentState.email ?? '';
      if (currentState.email != '') {
        storage.write(key: 'accessToken', value: accessToken);
        ref.read(sessionStateProvider.notifier).login(accessToken);
      }
    });

    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                  children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _tryLogin,
              child: const Text('Iniciar Sesión'),
            )
                  ],
                ),
          ),
        ));
  }

  void _tryLogin() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, introduce el usuario y la contraseña')),
      );
      return;
    }

    ref.read(userStateProvider.notifier).login(username, password);
  }
}
