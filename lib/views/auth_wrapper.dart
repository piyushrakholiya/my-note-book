import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase/views/home_page.dart';
import 'package:firebase/views/login_page.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {
        // Firebase authentication check ચાલી રહી છે
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // User logout છે / login નથી
        if (snapshot.data == null) {
          return const LoginPage();
        }

        // User Firebase માં login છે
        return const HomePage();
      },
    );
  }
}
