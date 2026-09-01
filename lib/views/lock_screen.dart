import 'package:firebase/utils/gradient_background.dart';
import 'package:firebase/viewmodels/lock_view_model.dart';
import 'package:firebase/views/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController pinController = TextEditingController();

  Future<void> unlock() async {
    final viewModel = context.read<LockViewModel>();

    final success = await viewModel.checkPin(pinController.text.trim());

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthWrapper()),
      );
    }
  }

  Future<void> authenticate() async {
    final viewModel = context.read<LockViewModel>();

    final success = await viewModel.authenticate();

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthWrapper()),
      );
    }
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LockViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("App Lock"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: GradientBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.lock, size: 80),

                const SizedBox(height: 20),

                const Text(
                  "Enter 6 Digit PIN",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: pinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: "6 Digit PIN",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                ElevatedButton(
                  onPressed: viewModel.isLoading ? null : unlock,
                  child: viewModel.isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Unlock"),
                ),

                const SizedBox(height: 20),

                IconButton(
                  onPressed: viewModel.isLoading ? null : authenticate,
                  icon: const Icon(Icons.fingerprint, size: 70),
                ),

                const Text("Use Fingerprint"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
