// import 'package:flutter/material.dart';

// import 'database_helper.dart';
// import 'note_manage_page.dart';

// class NotesPage extends StatefulWidget {
//   const NotesPage({super.key});

//   @override
//   State<NotesPage> createState() => _NotesPageState();
// }

// class _NotesPageState extends State<NotesPage> {
//   final DatabaseHelper dbHelper = DatabaseHelper.myDatabase;

//   List<Map<String, dynamic>> notes = [];

//   @override
//   void initState() {
//     super.initState();

//     fetchNotes();
//   }

//   Future<void> fetchNotes() async {
//     final data = await dbHelper.getNotes();

//     if (!mounted) return;

//     setState(() {
//       notes = data;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("My Notes")),

//       body: notes.isEmpty
//           ? const Center(
//               child: Text("No Notes Found", style: TextStyle(fontSize: 20)),
//             )
//           : ListView.builder(
//               itemCount: notes.length,

//               itemBuilder: (context, index) {
//                 final note = notes[index];

//                 return Card(
//                   margin: const EdgeInsets.all(10),

//                   child: ListTile(
//                     title: Text(note['title']),

//                     subtitle: Text(
//                       note['description'],
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),

//                     trailing: IconButton(
//                       icon: const Icon(Icons.edit),

//                       onPressed: () async {
//                         await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => NoteManagePage(
//                               noteId: note['id'],
//                               oldTitle: note['title'],
//                               oldDescription: note['description'],
//                             ),
//                           ),
//                         );

//                         fetchNotes();
//                       },
//                     ),
//                   ),
//                 );
//               },
//             ),

//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const NoteManagePage()),
//           );

//           fetchNotes();
//         },

//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
