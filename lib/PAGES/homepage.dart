import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:sem5_walle/PAGES/mainpage.dart'; // Your MainPage or HomePage after login
import '../AUTHPROVIDER/authservice.dart'; // Import the AuthService class

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();

    // Listen for auth state changes
    _authService.authStateChanges.listen((User? user) {
      if (user != null) {
        // If the user is already signed in, navigate to the main page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyApp1()), // Replace with your main page widget
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Sign-In"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add a SizedBox to display an image
            SizedBox(
              height: 100,
              width: 100,
              child: Image.asset('assets/walle_logo.jpg'), // Replace with your image path
            ),
            const SizedBox(height: 30),

            // Add a Text widget below the image
            const Text(
              "Sign Up to Wall-e today",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // Google Sign-In button
            SizedBox(
              height: 50,
              child: SignInButton(
                Buttons.google,
                text: "Sign Up with Google",
                onPressed: _handleGoogleSignIn,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Handle Google Sign-In
  void _handleGoogleSignIn() async {
    User? user = await _authService.signInWithGoogle();
    if (user != null) {
      // Navigate to the main page on successful sign-in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyApp1()), // Replace with your main page widget
      );
    }
  }
}
