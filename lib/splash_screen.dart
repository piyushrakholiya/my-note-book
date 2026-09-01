import 'package:firebase/utils/gradient_background.dart';
import 'package:firebase/views/lock_screen.dart';
import 'package:firebase/views/set_app_lock_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool checking = true;
  bool hasInternet = false;

  @override
  void initState() {
    super.initState();
    checkInterNet();
  }

  Future<void> checkInterNet() async {
    setState(() {
      checking = true;
    });

    final result = await Connectivity().checkConnectivity();

    if (!mounted) return;

    final connected =
        result.contains(ConnectivityResult.ethernet) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.mobile);

    setState(() {
      hasInternet = connected;
      checking = false;
    });

    if (connected) {
      checkAppLock();
    }
  }

  Future<void> checkAppLock() async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();

    final String? pin = prefs.getString("appLockPin");

    if (!mounted) return;

    if (pin == null || pin.isEmpty) {
      // First time → PIN set કરાવવો
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SetAppLockPage()),
      );
    } else {
      // PIN already exists → ફરી PIN set નહીં કરાવવો
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LockScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: checking
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),

                    SizedBox(height: 20),

                    Text(
                      "Checking Internet...",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ],
                )
              // ================= INTERNET AVAILABLE =================
              : hasInternet
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Icon
                    Icon(
                      Icons.menu_book_rounded,
                      size: 90,
                      color: Colors.white,
                    ),

                    SizedBox(height: 20),

                    // Welcome
                    Text(
                      "Welcome to MyNotes",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Your notes, beautifully organized.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),

                    SizedBox(height: 25),

                    SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              // ================= NO INTERNET =================
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.wifi_off_rounded,
                      size: 85,
                      color: Colors.white,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "No Internet Connection",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "Please turn on your Internet connection "
                        "and try again.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),

                    const SizedBox(height: 25),

                    ElevatedButton.icon(
                      onPressed: checkInterNet,
                      icon: const Icon(Icons.refresh),
                      label: const Text(
                        "Retry",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
