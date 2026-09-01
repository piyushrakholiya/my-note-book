import 'package:firebase/utils/gradient_background.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text("About My Notebook"),
        centerTitle: true,
        backgroundColor: const Color(0xFF6A11CB),
        foregroundColor: Colors.white,
      ),

      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              const SizedBox(height: 10),

              // ================= APP ICON =================
              Container(
                height: 110,
                width: 110,

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                  ),

                  borderRadius: BorderRadius.circular(30),

                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 18,
                      spreadRadius: 2,
                      offset: Offset(0, 8),
                      color: Colors.black26,
                    ),
                  ],
                ),

                child: const Icon(
                  Icons.menu_book_rounded,
                  size: 65,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 22),

              // ================= APP NAME =================
              const Text(
                "My Notebook",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                "Your notes, beautifully organized.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ================= ABOUT =================
              _infoCard(
                context,
                icon: Icons.info_outline_rounded,
                title: "About My Notebook",
                description:
                    "My Notebook is a simple and powerful note-taking "
                    "application designed to help you create, manage, "
                    "update and organize your notes easily.",
              ),

              const SizedBox(height: 15),

              // ================= NOTES =================
              _infoCard(
                context,
                icon: Icons.note_alt_outlined,
                title: "Notes Management",
                description:
                    "Create new notes, view your notes, update existing "
                    "notes and delete notes whenever you want.",
              ),

              const SizedBox(height: 15),

              // ================= FIREBASE =================
              _infoCard(
                context,
                icon: Icons.cloud_outlined,
                title: "Firebase",
                description:
                    "Firebase Authentication is used for secure user "
                    "login and account management. Your notes are "
                    "organized according to the logged-in user.",
              ),

              const SizedBox(height: 15),

              // ================= SECURITY =================
              _infoCard(
                context,
                icon: Icons.lock_outline_rounded,
                title: "App Security",
                description:
                    "The application supports app locking with a "
                    "6-digit PIN and fingerprint authentication.",
              ),

              const SizedBox(height: 15),

              // ================= DARK MODE =================
              _infoCard(
                context,
                icon: Icons.dark_mode_outlined,
                title: "Dark Mode",
                description:
                    "Switch between Light Mode and Dark Mode according "
                    "to your preference.",
              ),

              const SizedBox(height: 35),

              const Divider(),

              const SizedBox(height: 25),

              // ================= DEVELOPER =================
              const Text(
                "Developer",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              ClipOval(
                child: Image.asset(
                  "assets/images/piyush_logo.png",
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "Piyush Rakholia",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 5),

              Text(
                "Flutter Developer",
                style: TextStyle(
                  fontSize: 16,
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ================= BUILT WITH =================
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),

                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),

                  borderRadius: BorderRadius.circular(15),

                  border: Border.all(
                    color: primaryColor.withValues(alpha: 0.2),
                  ),
                ),

                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite, color: Colors.red, size: 20),

                    SizedBox(width: 8),

                    Text(
                      "Built with Flutter",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "Flutter • Firebase • Provider • SQLite",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 25),

              // ================= VERSION =================
              Text(
                "Version 1.0.0",
                style: TextStyle(
                  fontSize: 13,
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.6,
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

  // =========================================================
  // INFO CARD
  // =========================================================

  Widget _infoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,

      shadowColor: Colors.black26,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ICON
            Container(
              height: 52,
              width: 52,

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                ),

                borderRadius: BorderRadius.circular(15),
              ),

              child: Icon(icon, color: Colors.white, size: 27),
            ),

            const SizedBox(width: 15),

            // TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
