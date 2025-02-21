import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notes/add_new_task.dart';
import 'package:firebase_notes/edit_task.dart';
import 'package:firebase_notes/login_page.dart';
import 'package:firebase_notes/utils.dart';
import 'package:firebase_notes/widgets/date_selector.dart';
import 'package:firebase_notes/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const MyHomePage(),
      );
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime selectedDate = DateTime.now();
  bool showAllTasks = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showAllTasks = !showAllTasks;
          });
        },
        child: Text(showAllTasks ? 'DATE' : 'ALL'),
      ),
      appBar: AppBar(
        title: const Text('My Task'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddNewTask()));
          },
          icon: const Icon(
            Icons.add,
            size: 28,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(LoginPage.route());
            },
            icon: const Icon(
              Icons.logout,
              color: Color.fromARGB(255, 213, 55, 44),
              size: 28,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          DateSelector(
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
                showAllTasks = false;
              });
            },
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("tasks")
                .where('creator',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData) {
                return const Center(child: Text("No data here :("));
              }
              var filteredDocs = snapshot.data!.docs.where((doc) {
                if (showAllTasks) return true;
                var timestamp = doc['date'] as Timestamp;
                var date = timestamp.toDate();
                return date.year == selectedDate.year &&
                    date.month == selectedDate.month &&
                    date.day == selectedDate.day;
              }).toList();

              return Expanded(
                child: ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (BuildContext context, int index) {
                    var finalData = filteredDocs[index].data();
                    var timestamp = finalData['date'] as Timestamp;
                    var date = timestamp.toDate();
                    var formattedDate = DateFormat('dd/MM/yyyy').format(date);
                    var formattedTime = DateFormat('hh:mm a').format(date);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditTask(
                              taskId: filteredDocs[index].id,
                              title: finalData['title'],
                              description: finalData['description'],
                              date: date,
                              color: hexToColor(finalData['color']),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: TaskCard(
                              color: hexToColor(finalData['color']),
                              headerText: finalData['title'],
                              descriptionText: finalData['description'],
                              scheduledDate: formattedDate,
                              onDelete: () async {
                                await FirebaseFirestore.instance
                                    .collection("tasks")
                                    .doc(filteredDocs[index].id)
                                    .delete();
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.all(6.0).copyWith(left: 0),
                            child: Text(
                              formattedTime,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
