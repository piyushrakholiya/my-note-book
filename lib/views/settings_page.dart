import 'package:firebase/utils/gradient_background.dart';
import 'package:firebase/views/change_Password.dart';

import 'package:firebase/viewmodels/theme_view_model.dart';
import 'package:firebase/views/change_app_lock.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeViewModel = context.watch<ThemeViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            ),
          ),
        ),
      ),

      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 10),

            const Text(
              "App Settings",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // ================= DARK MODE =================
            Card(
              child: SwitchListTile(
                secondary: Icon(
                  themeViewModel.isDarkMode
                      ? Icons.dark_mode
                      : Icons.light_mode,
                ),

                title: const Text(
                  "Dark Mode",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                subtitle: Text(
                  themeViewModel.isDarkMode
                      ? "Dark theme is enabled"
                      : "Light theme is enabled",
                ),

                value: themeViewModel.isDarkMode,

                onChanged: (_) {
                  themeViewModel.toggleTheme();
                },
              ),
            ),

            const SizedBox(height: 12),

            // ================= CHANGE PASSWORD =================
            Card(
              child: ListTile(
                leading: const Icon(Icons.lock_outline),

                title: const Text(
                  "Change Password",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                subtitle: const Text("Change your account password"),

                trailing: const Icon(Icons.arrow_forward_ios, size: 18),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePassword(),
                    ),
                  );
                },
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.lock_reset),
                title: const Text("Change App Lock"),
                subtitle: const Text("Change your App Lock PIN"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangeAppLockPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
