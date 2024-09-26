import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCoKQfgmYz93-vyLP64g0m9fP3jGsDwkyw",
      projectId: "suitespot-8d1ba",
      messagingSenderId: "405319714500",
      appId: "1:405319714500:web:af37448d80d1790e4deb91",
    )
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Welcome to Suite Spot!'),
        ),
      ),
    );
  }
}
