import 'package:firebase/utils/gradient_background.dart';
import 'package:firebase/utils/ui_helper.dart';
import 'package:firebase/viewmodels/phone_signup_view_model.dart';
import 'package:firebase/views/home_page.dart';
import 'package:firebase/views/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhoneSignupPage extends StatefulWidget {
  const PhoneSignupPage({super.key});

  @override
  State<PhoneSignupPage> createState() => _PhoneSignupPageState();
}

class _PhoneSignupPageState extends State<PhoneSignupPage> {
  final phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future<void> sendOtp() async {
    String number = phoneController.text.trim();

    if (number.isEmpty) {
      UiHelper.customAlertBox(context: context, text: "Phone number નાખો");
      return;
    }

    String phone = "+91$number";

    final viewModel = context.read<PhoneSignupViewModel>();

    await viewModel.sendOtp(
      phone: phone,

      onCodeSent: (verificationId) {
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpPage(verificationId: verificationId),
          ),
        );
      },

      onVerificationCompleted: () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      },

      onVerificationFailed: (message) {
        if (!mounted) return;

        UiHelper.customAlertBox(context: context, text: message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = context.watch<PhoneSignupViewModel>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone Sign Up"),
        centerTitle: true,
        backgroundColor: Color(0xFF6A11CB),
        foregroundColor: Colors.white,
      ),

      body: GradientBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,

                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    hintText: "9876543210",
                    prefixText: "+91 ",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: isLoading ? null : sendOtp,

                    child: isLoading
                        ? const SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(),
                          )
                        : const Text("Send OTP"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
