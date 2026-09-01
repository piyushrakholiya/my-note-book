import 'package:firebase/utils/gradient_background.dart';
import 'package:flutter/material.dart';

class NoteDetailPage extends StatelessWidget {
  final String noteId;
  final String title;
  final String description;

  const NoteDetailPage({
    super.key,
    required this.noteId,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Note Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,

        backgroundColor: Color(0xFF6A11CB),

        foregroundColor: Colors.white,
      ),

      body: GradientBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Hero(
            tag: "note_$noteId",

            child: Material(
              color: Colors.transparent,

              child: Container(
                width: double.infinity,

                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(25),

                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 15,
                      offset: Offset(0, 8),
                      color: Colors.black26,
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // ================= NOTE ICON =================
                    Center(
                      child: Container(
                        height: 80,
                        width: 80,

                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                          ),

                          borderRadius: BorderRadius.circular(25),
                        ),

                        child: const Icon(
                          Icons.sticky_note_2_rounded,
                          color: Colors.white,
                          size: 45,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ================= TITLE =================
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Divider(),

                    const SizedBox(height: 20),

                    // ================= DESCRIPTION =================
                    Text(
                      description,
                      style: const TextStyle(fontSize: 18, height: 1.6),
                    ),

                    const SizedBox(height: 30),

                    // ================= NOTE ID =================
                    Text(
                      "Note ID: $noteId",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
