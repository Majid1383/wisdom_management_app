import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wisdom_management_app/screens/login/login_screen.dart';
import 'package:wisdom_management_app/theme/theme_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Error initializing Firebase: $e');
  }

  runApp(const WisdomClassApp());
}

class WisdomClassApp extends StatelessWidget {
  const WisdomClassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wisdom Class',
      debugShowCheckedModeBanner: false,
      theme: ThemeManager.lightTheme,
      home: const LoginScreen(),
    );
  }
}
