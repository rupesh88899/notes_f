import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes/utils.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditTask extends StatefulWidget {
  final String taskId;
  final String title;
  final String description;
  final DateTime date;
  final Color color;

  const EditTask({
    super.key,
    required this.taskId,
    required this.title,
    required this.description,
    required this.date,
    required this.color,
  });

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late DateTime selectedDate;
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.title);
    descriptionController = TextEditingController(text: widget.description);
    selectedDate = widget.date;
    selectedColor = widget.color;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> updateTask() async {
    try {
      await FirebaseFirestore.instance
          .collection("tasks")
          .doc(widget.taskId)
          .update({
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "date": selectedDate,
        "color": rgbToHex(selectedColor),
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(child: Text("Failed to edit task: ${e.message}")),
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
        title: const Text('Edit Task'),
        centerTitle: true,
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
                  hintText: "Description",
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
              ColorPicker(
                color: selectedColor,
                onColorChanged: (Color color) {
                  setState(() {
                    selectedColor = color;
                  });
                },
                heading: const Text('Select color'),
                subheading: const Text('Select shade'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await updateTask();

                  Navigator.pop(context);
                },
                child: const Text(
                  'UPDATE',
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
