import 'dart:io';

import 'package:firebase/utils/gradient_background.dart';
import 'package:firebase/utils/ui_helper.dart';
import 'package:firebase/viewmodels/signup_view_model.dart';
import 'package:firebase/views/database_helper.dart';
import 'package:firebase/views/set_app_lock_page.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  String? imagePath;

  @override
  void initState() {
    super.initState();
    loadProfileImage();
  }

  // ================= LOAD PROFILE IMAGE =================

  Future<void> loadProfileImage() async {
    final String? path = await DatabaseHelper.myDatabase.getProfileImage();

    if (!mounted) {
      return;
    }

    if (path != null) {
      setState(() {
        imagePath = path;
      });
    }
  }

  // ================= IMAGE PICKER DIALOG =================

  void showAlertBox() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pick image from"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // CAMERA
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Camera"),
                onTap: () async {
                  Navigator.pop(context);
                  await pickImageCamera();
                },
              ),

              // GALLERY
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  await pickImageGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= SIGNUP =================

  Future<void> signup() async {
    final String email = emailController.text.trim();

    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      UiHelper.customAlertBox(context: context, text: "Enter required fields");

      return;
    }

    final viewModel = context.read<SignupViewModel>();

    final bool success = await viewModel.signup(
      email: email,
      password: password,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      // =================
      // ACCOUNT CREATED
      // =================
      //
      // હવે સીધું Home નહીં.
      //
      // પહેલા user App Lock PIN set કરશે.

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SetAppLockPage()),
      );
    } else {
      UiHelper.customAlertBox(
        context: context,
        text: viewModel.errorMessage ?? "Signup failed",
      );
    }
  }

  // ================= DISPOSE =================

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    final bool isLoading = context.watch<SignupViewModel>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,

        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            ),
          ),
        ),

        foregroundColor: Colors.white,
      ),

      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const SizedBox(height: 50),

              // ================= PROFILE IMAGE =================
              GestureDetector(
                onTap: showAlertBox,

                child: imagePath != null
                    ? CircleAvatar(
                        radius: 80,
                        backgroundImage: FileImage(File(imagePath!)),
                      )
                    : const CircleAvatar(
                        radius: 80,
                        child: Icon(Icons.person_2, size: 80),
                      ),
              ),

              const SizedBox(height: 30),

              // ================= EMAIL =================
              TextField(
                controller: emailController,

                keyboardType: TextInputType.emailAddress,

                style: const TextStyle(color: Colors.white),

                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: const TextStyle(color: Colors.white),

                  hintText: "Enter your email",

                  hintStyle: const TextStyle(color: Colors.white70),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(color: Colors.white70),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // ================= PASSWORD =================
              TextField(
                controller: passwordController,

                obscureText: true,

                style: const TextStyle(color: Colors.white),

                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(color: Colors.white),

                  hintText: "Enter your password",

                  hintStyle: const TextStyle(color: Colors.white70),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(color: Colors.white70),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ================= SIGN UP BUTTON =================
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                onPressed: isLoading ? null : signup,

                child: isLoading
                    ? const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(),
                      )
                    : const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ================= GALLERY =================

  Future<void> pickImageGallery() async {
    final XFile? pick = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pick != null) {
      final String? path = await DatabaseHelper.myDatabase.saveImagePermanently(
        pick,
      );

      if (path != null) {
        await DatabaseHelper.myDatabase.saveProfileImage(path);

        if (!mounted) {
          return;
        }

        setState(() {
          imagePath = path;
        });
      }
    }
  }

  // ================= CAMERA =================

  Future<void> pickImageCamera() async {
    final XFile? pick = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (pick != null) {
      final String? path = await DatabaseHelper.myDatabase.saveImagePermanently(
        pick,
      );

      if (path != null) {
        await DatabaseHelper.myDatabase.saveProfileImage(path);

        if (!mounted) {
          return;
        }

        setState(() {
          imagePath = path;
        });
      }
    }
  }
}
