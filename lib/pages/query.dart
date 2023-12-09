// ignore_for_file: use_build_context_synchronously

import 'package:ase456_hw8_individual_project/components/show_snackbar.dart';
import 'package:ase456_hw8_individual_project/components/tag_input.dart';
import 'package:ase456_hw8_individual_project/components/task_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class QueryRecord extends StatelessWidget {
  var queryDateController = TextEditingController();
  var queryTitleController = TextEditingController();
  var queryTagController = TextEditingController();
  final FirebaseFirestore fireStore;

  QueryRecord({super.key, required this.fireStore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(child: Text('Query an Activity')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TaskInput(
                controller: queryTitleController, hintText: 'Enter a Task'),
            const SizedBox(height: 16),
            TextField(
              controller: queryDateController,
              decoration: const InputDecoration(hintText: 'Enter a Date'),
            ),
            const SizedBox(height: 16),
            TagInput(controller: queryTagController, hintText: 'Enter a Tag'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                List<Map<String, dynamic>> resultsList = [];
                if (queryDateController.text == 'today') {
                  String date =
                      DateTime.now().toLocal().toString().split(' ')[0];
                  CollectionReference records = fireStore.collection('records');
                  try {
                    QuerySnapshot querySnapshot =
                        await records.where('date', isEqualTo: date).get();
                    querySnapshot.docs.forEach(
                      (DocumentSnapshot document) {
                        Map<String, dynamic> results =
                            document.data() as Map<String, dynamic>;
                        resultsList.add(results);
                      },
                    );
                  } catch (error) {
                    ShowSnackBar(
                            content: 'Error querying data: $error',
                            context: context,
                            duration: 3)
                        .show();
                  }
                }
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Query Result'),
                      content: SingleChildScrollView(
                        child: Column(
                          children: resultsList.map((result) {
                            return ListTile(
                              title: Text(
                                result['title'] ?? '',
                                style: const TextStyle(fontSize: 30),
                              ),
                              subtitle: Text(
                                  'DATE: ${result['date']}\nTAGS: ${result['tag'].toString()}\nFROM: ${result['from']}\nTO: ${result['to']}'),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text('Submit Query'),
            )
          ],
        ),
      ),
    );
  }
}
 //QUERY
            