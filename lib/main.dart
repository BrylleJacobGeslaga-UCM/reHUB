import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'firebase_options.dart';
import 'screens/auth_gate.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();

  // Keep the splash screen up until AuthGate knows what to show.
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  // Safety net: never leave the splash up forever (e.g. no internet).
  Future.delayed(const Duration(seconds: 8), FlutterNativeSplash.remove);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const RehubApp());
}

class RehubApp extends StatelessWidget {
  const RehubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'reHUB',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const AuthGate(),
    );
  }
}
