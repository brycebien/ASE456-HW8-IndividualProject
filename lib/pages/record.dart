import 'package:ase456_hw8_individual_project/components/date_input.dart';
import 'package:ase456_hw8_individual_project/components/show_snackbar.dart';
import 'package:ase456_hw8_individual_project/components/tag_input.dart';
import 'package:ase456_hw8_individual_project/components/task_input.dart';
import 'package:ase456_hw8_individual_project/components/time_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Record extends StatelessWidget {
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var tagsController = TextEditingController();
  var startTimeController = TextEditingController();
  var endTimeController = TextEditingController();
  final FirebaseFirestore fireStore;

  Record({super.key, required this.fireStore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(child: Text('Record an Activity')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            //TASK
            const Text('Input a task:'),
            TaskInput(
              controller: titleController,
              hintText: 'Enter a task',
            ),
            const SizedBox(height: 16),

            //DATE
            const Text('Task Date:'),
            DateInput(
              controller: dateController,
              context: context,
              hintText: 'Enter a date',
            ),
            const SizedBox(height: 16),

            //START TIME
            const Text('Start Time:'),
            TimeInput(
              controller: startTimeController,
              context: context,
              hintText: 'Select start time',
            ),
            const SizedBox(height: 16),

            //END TIME
            const Text('End Time:'),
            TimeInput(
              controller: endTimeController,
              context: context,
              hintText: 'Select end time',
            ),
            const SizedBox(height: 16),

            //TAG
            const Text('Tag:'),
            TagInput(
              controller: tagsController,
              hintText: 'Enter Tags (comma-seperated)',
            ),
            const SizedBox(height: 16),

            //INPUT BUTTON
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty ||
                    dateController.text.isEmpty ||
                    startTimeController.text.isEmpty ||
                    endTimeController.text.isEmpty ||
                    tagsController.text.isEmpty) {
                  ShowSnackBar(
                          content:
                              'Fill out every input field to submit a record',
                          context: context,
                          duration: 3)
                      .show();
                  return;
                }
                //format tags to array
                List<String> tags =
                    tagsController.text.replaceAll(' ', '').split(',');
                tags = tags
                    .map((tag) => tag.startsWith(':')
                        ? tag.toUpperCase()
                        : ':$tag'.toUpperCase())
                    .toList();
                //Map data to JSON
                Map<String, dynamic> data = {
                  'title': titleController.text,
                  'date': dateController.text,
                  'from': startTimeController.text,
                  'to': endTimeController.text,
                  'tag': tags
                };
                //input data to db
                fireStore.collection('records').doc().set(data).then((value) {
                  ShowSnackBar(
                          content: 'Task added successfully!',
                          context: context,
                          duration: 3)
                      .show();
                }).catchError((error) {
                  ShowSnackBar(
                          content: 'error adding task: $error',
                          context: context,
                          duration: 3)
                      .show();
                  print('Error adding task $error');
                });
              },
              child: const Text('Submit Record'),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
