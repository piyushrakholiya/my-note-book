import 'package:firebase/splash_screen.dart';
import 'package:firebase/viewmodels/auth_view_model.dart';
import 'package:firebase/viewmodels/lock_view_model.dart';

import 'package:firebase/viewmodels/add_note_view_model.dart';

import 'package:firebase/viewmodels/change_password_view_model.dart';
import 'package:firebase/viewmodels/forgot_password_view_model.dart';
import 'package:firebase/viewmodels/login_view_model.dart';
import 'package:firebase/viewmodels/notes_view_model.dart';
import 'package:firebase/viewmodels/phone_signup_view_model.dart';
import 'package:firebase/viewmodels/signup_view_model.dart';
import 'package:firebase/viewmodels/theme_view_model.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SignupViewModel()),
        ChangeNotifierProvider(create: (_) => PhoneSignupViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => NotesViewModel()),
        ChangeNotifierProvider(create: (_) => AddNoteViewModel()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => LockViewModel()),
        ChangeNotifierProvider(create: (_) => ChangePasswordViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeViewModel = context.watch<ThemeViewModel>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        colorSchemeSeed: Colors.deepPurple,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.deepPurple,
      ),

      themeMode: themeViewModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      home: const SplashScreen(),
    );
  }
}
