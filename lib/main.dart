import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isRegistering = false;
  bool _isLoading = false;

    // Check for existing user accounts
    Future<void> _login() async {
      setState(() {
        _isLoading = true;
      });

      try {
        // Authenticate the user with Firebase Authentication
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Fetch user details from Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('accounts')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          // Retrieve the username from the Firestore document
          String username = userDoc.get('username');

          // Show a welcome message with the username
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome back, $username!')),
          );
          
          // Navigate to HomePage if login is successful
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User data not found in Firestore!')),
          );
        }
      } on FirebaseAuthException catch (e) {
        // Handle errors from Firebase Authentication
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'An error occurred!')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }

    // Registering a new user account
    Future<void> _registerUser(String email, String password, String username, String phoneNum) async {
      try {
        // Create user in Firebase Authentication
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Get the UID of the newly created user
        String uid = userCredential.user!.uid;

        // Save user data in Firestore
        await _firestore.collection('accounts').doc(uid).set({
          'eMail': email,
          'password': password,
          'username': username,
          'phoneNum': phoneNum,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful!')),
        );

        // Redirect to login page
        setState(() {
          isRegistering = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/loginBG.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Welcome Text outside of the form container
              Text(
                'Welcome to Suite Spot',
                style: TextStyle(
                  fontFamily: 'Italiana-Regular',
                  fontSize: 45,
                  color: Color.fromRGBO(232, 204, 191, 1),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20), 

          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400, // Fixed width for the form
              maxHeight: 500, // Fixed height for the form
            ),
            child: Card(
              elevation: 8.0,
              color: Color.fromRGBO(232, 204, 191, 0.75),
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
            ],
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
          'Log In',
          style: TextStyle(
            fontFamily: 'Italiana-Regular',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'E-Mail',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
          ),
        ),
        const SizedBox(height: 20),
        
        _isLoading
          ? CircularProgressIndicator()
          : ElevatedButton(
            onPressed: _login,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Login'),
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
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Column(
      key: const ValueKey('registrationForm'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Register an Account',
          style: TextStyle(
            fontFamily: 'Italiana-Regular',
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email Address',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: phoneController,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.phone),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
          ),
        ),
        const SizedBox(height: 20),
        
        // Register Button
      ElevatedButton(
        onPressed: () async {
          setState(() {
            _isLoading = true;
          });

          try {
            // Call the _registerUser method with form input
            await _registerUser(
              emailController.text.trim(),
              passwordController.text.trim(),
              usernameController.text.trim(),
              phoneController.text.trim(),
            );

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration successful!')),
            );

            // Redirect to Login page
            setState(() {
              isRegistering = false;
            });
          } catch (e) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Registration failed: $e')),
            );
          } finally {
            setState(() {
              _isLoading = false;
            });
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Register'),
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