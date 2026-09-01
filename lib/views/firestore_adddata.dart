import 'package:firebase/utils/ui_helper.dart';
import 'package:firebase/viewmodels/add_note_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirestoreAdddata extends StatefulWidget {
  const FirestoreAdddata({super.key});

  @override
  State<FirestoreAdddata> createState() => _FirestoreAdddataState();
}

class _FirestoreAdddataState extends State<FirestoreAdddata> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  Future<void> addData() async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      UiHelper.customAlertBox(context: context, text: "enter all detail");
      return;
    }

    final viewModel = context.read<AddNoteViewModel>();

    final success = await viewModel.addNote(
      title: title,
      description: description,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    } else {
      UiHelper.customAlertBox(context: context, text: "Note add failed");
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("add note"),
        centerTitle: true,
        backgroundColor: Color(0xFF6A11CB),
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(21),
              ),
              suffixIcon: const Icon(Icons.title),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: descriptionController,
            maxLines: 6,
            decoration: InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(21),
              ),
              suffixIcon: const Icon(Icons.description),
            ),
          ),

          const SizedBox(height: 15),

          ElevatedButton(onPressed: addData, child: const Text("add note")),
        ],
      ),
    );
  }
}
