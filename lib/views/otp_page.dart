import 'package:firebase/utils/gradient_background.dart';

import 'package:firebase/utils/ui_helper.dart';
import 'package:firebase/views/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OtpPage extends StatefulWidget {
  final String verificationId;

  const OtpPage({super.key, required this.verificationId});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final otpController = TextEditingController();

  bool loading = false;

  Future<void> verifyOtp() async {
    String otp = otpController.text.trim();

    if (otp.isEmpty) {
      UiHelper.customAlertBox(context: context, text: "OTP નાખો");
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      // verificationId + OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );

      // OTP verify + Phone account create/login
      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) return;

      UiHelper.customAlertBox(
        context: context,
        text: "Phone verified successfully",
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      UiHelper.customAlertBox(
        context: context,
        text: e.message ?? "OTP ખોટો છે",
      );
    }
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
        centerTitle: true,
        backgroundColor: Color(0xFF6A11CB),
        foregroundColor: Colors.white,
      ),

      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: "Enter OTP",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(15),
                    ),
                    maximumSize: Size(200, 40),
                  ),
                  onPressed: loading ? null : verifyOtp,
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text("Verify OTP"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
