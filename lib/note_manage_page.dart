// import 'package:flutter/material.dart';

// import 'database_helper.dart';

// class NoteManagePage extends StatefulWidget {
//   final int? noteId;
//   final String? oldTitle;
//   final String? oldDescription;

//   const NoteManagePage({
//     super.key,
//     this.noteId,
//     this.oldTitle,
//     this.oldDescription,
//   });

//   @override
//   State<NoteManagePage> createState() => _NoteManagePageState();
// }

// class _NoteManagePageState extends State<NoteManagePage> {
//   final DatabaseHelper dbHelper = DatabaseHelper.myDatabase;

//   final TextEditingController titleController = TextEditingController();

//   final TextEditingController descriptionController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();

//     titleController.text = widget.oldTitle ?? "";

//     descriptionController.text = widget.oldDescription ?? "";
//   }

//   // ADD
//   Future<void> addNote() async {
//     String title = titleController.text.trim();

//     String description = descriptionController.text.trim();

//     if (title.isEmpty || description.isEmpty) {
//       return;
//     }

//     await dbHelper.addNote(title, description);

//     if (!mounted) return;

//     Navigator.pop(context);
//   }

//   // UPDATE
//   Future<void> updateNote() async {
//     String title = titleController.text.trim();

//     String description = descriptionController.text.trim();

//     if (title.isEmpty || description.isEmpty) {
//       return;
//     }

//     await dbHelper.updateNote(widget.noteId!, title, description);

//     if (!mounted) return;

//     Navigator.pop(context);
//   }

//   // DELETE
//   Future<void> deleteNote() async {
//     await dbHelper.deleteNote(widget.noteId!);

//     if (!mounted) return;

//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isUpdate = widget.noteId != null;

//     return Scaffold(
//       appBar: AppBar(title: Text(isUpdate ? "Update Note" : "Add Note")),

//       body: Padding(
//         padding: const EdgeInsets.all(16),

//         child: Column(
//           children: [
//             TextField(
//               controller: titleController,

//               decoration: const InputDecoration(
//                 labelText: "Title",
//                 border: OutlineInputBorder(),
//               ),
//             ),

//             const SizedBox(height: 15),

//             TextField(
//               controller: descriptionController,

//               maxLines: 6,

//               decoration: const InputDecoration(
//                 labelText: "Description",
//                 border: OutlineInputBorder(),
//               ),
//             ),

//             const SizedBox(height: 20),

//             ElevatedButton(
//               onPressed: isUpdate ? updateNote : addNote,

//               child: Text(isUpdate ? "Update Note" : "Add Note"),
//             ),

//             if (isUpdate) ...[
//               const SizedBox(height: 10),

//               ElevatedButton(
//                 onPressed: deleteNote,

//                 child: const Text("Delete Note"),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
