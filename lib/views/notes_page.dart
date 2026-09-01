import 'dart:async';

import 'package:firebase/utils/gradient_background.dart';
import 'package:firebase/utils/ui_helper.dart';
import 'package:firebase/viewmodels/notes_view_model.dart';
import 'package:firebase/views/note_detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();

    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null && mounted) {
        Navigator.of(context).pop();
      }
    });
  }
  // ================= UPDATE NOTE =================

  void showUpdateBottomSheet(
    String noteId,
    String oldTitle,
    String oldDescription,
  ) {
    final TextEditingController titleController = TextEditingController(
      text: oldTitle,
    );

    final TextEditingController descriptionController = TextEditingController(
      text: oldDescription,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Update Note",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Title",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {
                    final String title = titleController.text.trim();

                    final String description = descriptionController.text
                        .trim();

                    if (title.isEmpty || description.isEmpty) {
                      UiHelper.customAlertBox(
                        context: context,
                        text: "Enter all detail",
                      );
                      return;
                    }

                    final viewModel = context.read<NotesViewModel>();

                    final bool success = await viewModel.updateNote(
                      noteId: noteId,
                      title: title,
                      description: description,
                    );

                    if (!context.mounted) {
                      return;
                    }

                    if (success) {
                      Navigator.pop(context);

                      UiHelper.customAlertBox(
                        context: context,
                        text: "Note updated",
                      );
                    } else {
                      UiHelper.customAlertBox(
                        context: context,
                        text: "Note update failed",
                      );
                    }
                  },
                  child: const Text("Update"),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= DELETE NOTE =================

  void deleteNote(String noteId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Note"),
          content: const Text("Are you sure you want to delete this note?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            TextButton(
              onPressed: () async {
                final viewModel = context.read<NotesViewModel>();

                final bool success = await viewModel.deleteNote(noteId);

                if (!context.mounted) {
                  return;
                }

                Navigator.pop(context);

                if (success) {
                  UiHelper.customAlertBox(
                    context: context,
                    text: "Note deleted",
                  );
                } else {
                  UiHelper.customAlertBox(
                    context: context,
                    text: "Note delete failed",
                  );
                }
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<NotesViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Notes",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,

        backgroundColor: Color(0xFF6A11CB),

        foregroundColor: Colors.white,
      ),

      body: GradientBackground(
        child: StreamBuilder(
          stream: viewModel.fetchNotes(),

          builder: (context, snapshot) {
            // ================= LOADING =================

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // ================= ERROR =================

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            // ================= NO NOTES =================

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No notes found",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            final notes = snapshot.data!.docs;

            // ================= NOTES LIST =================

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

              itemCount: notes.length,

              itemBuilder: (context, index) {
                final note = notes[index];

                final String noteId = note.id;

                final String title = note["title"] ?? "";

                final String description = note["description"] ?? "";

                return Hero(
                  tag: "note_$noteId",

                  child: Material(
                    color: Colors.transparent,

                    child: Card(
                      margin: const EdgeInsets.only(bottom: 12),

                      elevation: 5,

                      shadowColor: Colors.black38,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NoteDetailPage(
                                noteId: noteId,
                                title: title,
                                description: description,
                              ),
                            ),
                          );
                        },

                        child: Padding(
                          padding: const EdgeInsets.all(16),

                          child: Row(
                            children: [
                              // ================= ICON =================
                              Container(
                                height: 52,
                                width: 52,

                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF6A11CB),
                                      Color(0xFF2575FC),
                                    ],
                                  ),

                                  borderRadius: BorderRadius.circular(15),
                                ),

                                child: const Icon(
                                  Icons.sticky_note_2_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),

                              const SizedBox(width: 15),

                              // ================= TITLE + DESCRIPTION =================
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,

                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,

                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // ================= MENU =================
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == "edit") {
                                    showUpdateBottomSheet(
                                      noteId,
                                      title,
                                      description,
                                    );
                                  }

                                  if (value == "delete") {
                                    deleteNote(noteId);
                                  }
                                },

                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: "edit",
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit),
                                        SizedBox(width: 10),
                                        Text("Edit"),
                                      ],
                                    ),
                                  ),

                                  const PopupMenuItem(
                                    value: "delete",
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete),
                                        SizedBox(width: 10),
                                        Text("Delete"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
