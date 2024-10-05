import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wall_app/auth/auth.dart';
import 'package:wall_app/firebase_options.dart';

Future<void> configure() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configure();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
