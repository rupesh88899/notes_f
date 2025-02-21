import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes/utils.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  // ignore: unused_field
  Color _selectedColor = Colors.blue;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  //fumction to store data to cloud_firebaseStore
  Future<void> uploadTaskToDo() async {
    try {
      final id = const Uuid().v4();

      await FirebaseFirestore.instance.collection("tasks").doc(id).set({
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "date": selectedDate,
        "creator": FirebaseAuth.instance.currentUser!.uid,
        "postedAt": FieldValue.serverTimestamp(),
        "color": rgbToHex(_selectedColor),
        "id": id,
      });

      // Show success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Center(child: Text('Task saved successfully')),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text("Failed to save task: ${e.message}")),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Task'),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () async {
              final selDate = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(
                  const Duration(days: 90),
                ),
              );
              if (selDate != null) {
                setState(() {
                  selectedDate = selDate;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                DateFormat('d/MM/y').format(selectedDate),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Title",
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: "Title",
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 10),

              //color picker
              ColorPicker(
                color: Colors.blue,
                onColorChanged: (Color color) {
                  setState(() {
                    _selectedColor = color;
                  });
                },
                heading: const Text('Select color'),
                subheading: const Text('Select shade'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final navContext = context; // Store context before await
                  await uploadTaskToDo();
                  if (navContext.mounted) {
                    // Ensure context is still valid
                    Navigator.pop(navContext);
                  }
                },
                child: const Text(
                  'SUBMIT',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
