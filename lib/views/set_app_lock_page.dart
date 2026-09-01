import 'package:firebase/utils/gradient_background.dart';

import 'package:firebase/views/lock_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetAppLockPage extends StatefulWidget {
  const SetAppLockPage({super.key});

  @override
  State<SetAppLockPage> createState() => _SetAppLockPageState();
}

class _SetAppLockPageState extends State<SetAppLockPage> {
  final TextEditingController pinController = TextEditingController();

  final TextEditingController confirmPinController = TextEditingController();

  bool isLoading = false;

  bool obscurePin = true;
  bool obscureConfirmPin = true;

  // ================= SET PIN =================

  Future<void> setPin() async {
    final String pin = pinController.text.trim();

    final String confirmPin = confirmPinController.text.trim();

    // PIN length check

    if (pin.length != 6) {
      _showMessage("PIN must be 6 digits");
      return;
    }

    // Confirm PIN length check

    if (confirmPin.length != 6) {
      _showMessage("Confirm PIN must be 6 digits");
      return;
    }

    // PIN match check

    if (pin != confirmPin) {
      _showMessage("PIN does not match");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();

      // Save PIN

      await prefs.setString("appLockPin", pin);

      if (!mounted) {
        return;
      }

      // Go to Home

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LockScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showMessage("Unable to save PIN");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ================= MESSAGE =================

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // ================= DISPOSE =================

  @override
  void dispose() {
    pinController.dispose();
    confirmPinController.dispose();

    super.dispose();
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Set App Lock"),
        centerTitle: true,

        backgroundColor: Colors.deepPurple,

        foregroundColor: Colors.white,
      ),

      body: GradientBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 30,
            bottom: MediaQuery.of(context).viewInsets.bottom + 30,
          ),

          child: Column(
            children: [
              const SizedBox(height: 30),

              // ================= LOCK ICON =================
              Container(
                height: 100,
                width: 100,

                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.lock_rounded,
                  size: 60,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 25),

              // ================= TITLE =================
              const Text(
                "Create App Lock",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Set a 6 digit PIN to protect your notes",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),

              const SizedBox(height: 35),

              // ================= PIN =================
              TextField(
                controller: pinController,

                keyboardType: TextInputType.number,

                obscureText: obscurePin,

                maxLength: 6,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 5,
                ),

                decoration: InputDecoration(
                  labelText: "6 Digit PIN",

                  labelStyle: const TextStyle(color: Colors.white),

                  hintText: "Enter PIN",

                  hintStyle: const TextStyle(color: Colors.white60),

                  counterStyle: const TextStyle(color: Colors.white70),

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePin = !obscurePin;
                      });
                    },

                    icon: Icon(
                      obscurePin ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                    ),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.white70),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // ================= CONFIRM PIN =================
              TextField(
                controller: confirmPinController,

                keyboardType: TextInputType.number,

                obscureText: obscureConfirmPin,

                maxLength: 6,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 5,
                ),

                decoration: InputDecoration(
                  labelText: "Confirm PIN",

                  labelStyle: const TextStyle(color: Colors.white),

                  hintText: "Enter PIN again",

                  hintStyle: const TextStyle(color: Colors.white60),

                  counterStyle: const TextStyle(color: Colors.white70),

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureConfirmPin = !obscureConfirmPin;
                      });
                    },

                    icon: Icon(
                      obscureConfirmPin
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white,
                    ),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.white70),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ================= SET PIN BUTTON =================
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),

                onPressed: isLoading ? null : setPin,

                child: isLoading
                    ? const SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(),
                      )
                    : const Text(
                        "Set App Lock",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
