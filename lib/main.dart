import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "package:cached_network_image/cached_network_image.dart";
import 'package:suite_spot/homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCoKQfgmYz93-vyLP64g0m9fP3jGsDwkyw",
      projectId: "suitespot-8d1ba",
      messagingSenderId: "405319714500",
      appId: "1:405319714500:web:af37448d80d1790e4deb91",
    )
  );
  runApp(const SuiteSpotApp());
}

class SuiteSpotApp extends StatelessWidget {
  const SuiteSpotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suite Spot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isRegistering = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              'https://invisionstudio.com/wp-content/uploads/2015/06/Hotels-360-Tours-Property-Photography-Architecural-Photography-Hotel-Photography.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: isRegistering ? _buildRegistrationForm() : _buildLoginForm(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      key: const ValueKey('loginForm'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Welcome to Suite Spot',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 20),
        const TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Add authentication logic here
            // Assuming the login is successful, navigate to the HomePage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          child: const Text('Login'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            setState(() {
              isRegistering = true;
            });
          },
          child: const Text('New user? Register here'),
        ),
      ],
    );
  }

  Widget _buildRegistrationForm() {
    return Column(
      key: const ValueKey('registrationForm'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Register an Account',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 20),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Email Address',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 20),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
        ),
        const SizedBox(height: 20),
        const TextField(
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Add registration logic here
          },
          child: const Text('Register'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            setState(() {
              isRegistering = false;
            });
          },
          child: const Text('Already have an account? Login here'),
        ),
      ],
    );
  }
}