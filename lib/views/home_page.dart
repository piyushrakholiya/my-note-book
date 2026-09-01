import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase/viewmodels/notes_view_model.dart';
import 'package:firebase/views/about_page.dart';
import 'package:firebase/views/database_helper.dart';

import 'package:firebase/views/firestore_adddata.dart';
import 'package:firebase/views/notes_page.dart';
import 'package:firebase/views/settings_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // =========================================================
  // NOTES STREAM
  // =========================================================

  Stream<QuerySnapshot<Map<String, dynamic>>>? notesStream;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    // User login હોય ત્યારે જ Firestore listener બનાવવો
    if (user != null) {
      notesStream = context.read<NotesViewModel>().fetchNotes();
    }
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =====================================================
      // APP BAR
      // =====================================================
      appBar: AppBar(
        title: const Text(
          "My Notebook",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      // =====================================================
      // DRAWER
      // =====================================================
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // =================================================
            // DRAWER HEADER
            // =================================================
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                ),
              ),

              child: FutureBuilder<String?>(
                future: DatabaseHelper.myDatabase.getProfileImage(),
                builder: (context, snapshot) {
                  final imagePath = snapshot.data;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,

                        backgroundImage:
                            imagePath != null && imagePath.isNotEmpty
                            ? FileImage(File(imagePath))
                            : null,

                        child: imagePath == null || imagePath.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 35,
                                color: Colors.deepPurple,
                              )
                            : null,
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "My Notebook",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Text(
                        "Your personal notes",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  );
                },
              ),
            ),

            // =================================================
            // ADD NOTE
            // =================================================
            ListTile(
              leading: const Icon(Icons.note_add),
              title: const Text("Add Note"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FirestoreAdddata(),
                  ),
                );
              },
            ),

            // =================================================
            // ALL NOTES
            // =================================================
            ListTile(
              leading: const Icon(Icons.notes),
              title: const Text("All Notes"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotesPage()),
                );
              },
            ),

            const Divider(),

            // =================================================
            // SETTINGS
            // =================================================
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),

            // =================================================
            // LOGOUT
            // =================================================
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () async {
                // Drawer પહેલા close કરો
                Navigator.pop(context);

                // Firebase logout
                await FirebaseAuth.instance.signOut();
              },
            ),

            // =================================================
            // ABOUT
            // =================================================
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("About"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
          ],
        ),
      ),

      // =====================================================
      // BODY
      // =====================================================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =================================================
            // WELCOME
            // =================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                ),

                borderRadius: BorderRadius.circular(25),

                boxShadow: const [
                  BoxShadow(
                    blurRadius: 12,
                    offset: Offset(0, 6),
                    color: Colors.black26,
                  ),
                ],
              ),

              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Welcome back 👋",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),

                        SizedBox(height: 6),

                        Text(
                          "Capture your ideas.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          "Write it. Save it. Remember it.",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  const Icon(
                    Icons.menu_book_rounded,
                    size: 75,
                    color: Colors.white,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // =================================================
            // QUICK ACTIONS
            // =================================================
            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                // ADD NOTE
                Expanded(
                  child: _actionCard(
                    icon: Icons.note_add_rounded,
                    title: "Add Note",
                    subtitle: "Create new",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FirestoreAdddata(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 15),

                // ALL NOTES
                Expanded(
                  child: _actionCard(
                    icon: Icons.library_books_rounded,
                    title: "All Notes",
                    subtitle: "View notes",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotesPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // =================================================
            // YOUR NOTEBOOK
            // =================================================
            const Text(
              "Your Notebook",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                // =================================================
                // TOTAL NOTES
                // =================================================
                Expanded(
                  child: _statCard(
                    icon: Icons.notes_rounded,

                    number: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: notesStream,

                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Text(
                            "0",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }

                        if (!snapshot.hasData) {
                          return const Text(
                            "0",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }

                        final int totalNotes = snapshot.data!.docs.length;

                        return Text(
                          "$totalNotes",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),

                    title: "Total Notes",
                  ),
                ),

                const SizedBox(width: 12),

                // =================================================
                // THIS WEEK
                // =================================================
                Expanded(
                  child: _statCard(
                    icon: Icons.today_rounded,

                    number: const Text(
                      "4",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    title: "This Week",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // =================================================
            // RECENT NOTES
            // =================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Notes",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotesPage(),
                      ),
                    );
                  },
                  child: const Text("View All"),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // =================================================
            // SAMPLE NOTE 1
            // =================================================
            _recentNote(
              title: "Flutter Learning",
              description: "Today I learned about Provider and ChangeNotifier.",
              icon: Icons.code,
            ),

            // =================================================
            // SAMPLE NOTE 2
            // =================================================
            _recentNote(
              title: "My Ideas",
              description: "Ideas for improving my notebook application.",
              icon: Icons.lightbulb,
            ),

            // =================================================
            // SAMPLE NOTE 3
            // =================================================
            _recentNote(
              title: "Shopping List",
              description: "Milk, vegetables, fruits and other items.",
              icon: Icons.shopping_cart,
            ),

            const SizedBox(height: 25),

            // =================================================
            // QUICK TIP
            // =================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.08),

                borderRadius: BorderRadius.circular(20),

                border: Border.all(
                  color: Colors.deepPurple.withValues(alpha: 0.2),
                ),
              ),

              child: const Row(
                children: [
                  Icon(Icons.lightbulb, size: 35, color: Colors.deepPurple),

                  SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Quick Tip",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text("Write down your ideas before you forget them."),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // ACTION CARD
  // =========================================================

  Widget _actionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(20),

      child: Container(
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(20),

          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              offset: Offset(0, 4),
              color: Colors.black12,
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            CircleAvatar(
              radius: 27,

              backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),

              child: Icon(icon, color: Colors.deepPurple, size: 28),
            ),

            const SizedBox(height: 15),

            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // STAT CARD
  // =========================================================

  Widget _statCard({
    required IconData icon,
    required Widget number,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
        ),

        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 35),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              number,

              Text(title, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================
  // RECENT NOTE
  // =========================================================

  Widget _recentNote({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: const [
          BoxShadow(blurRadius: 7, offset: Offset(0, 3), color: Colors.black12),
        ],
      ),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),

          child: Icon(icon, color: Colors.deepPurple),
        ),

        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),

        subtitle: Text(
          description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
