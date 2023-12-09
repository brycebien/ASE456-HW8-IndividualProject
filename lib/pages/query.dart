// ignore_for_file: use_build_context_synchronously

import 'package:ase456_hw8_individual_project/components/show_snackbar.dart';
import 'package:ase456_hw8_individual_project/components/tag_input.dart';
import 'package:ase456_hw8_individual_project/components/task_input.dart';
import 'package:ase456_hw8_individual_project/utility/date_validator.dart';
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
                CollectionReference records = fireStore.collection('records');
                Map<String, dynamic> query = {};

                if (queryDateController.text != '' ||
                    queryTagController.text != '' ||
                    queryTitleController.text != '') {
                  String date =
                      DateValidator.ValidateDate(queryDateController.text);

                  query['date'] = date;
                  query['tag'] = ':${queryTagController.text.toUpperCase()}';
                  query['task'] = queryTitleController.text;
                  Query querySearch = records;
                  querySearch = query['date'] != ''
                      ? querySearch.where('date', isEqualTo: query['date'])
                      : querySearch;
                  querySearch = query['tag'] != ':'
                      ? querySearch.where('tag', isEqualTo: query['tag'])
                      : querySearch;
                  querySearch = query['task'] != ''
                      ? querySearch.where('title', isEqualTo: query['task'])
                      : querySearch;
                  try {
                    QuerySnapshot querySnapshot = await querySearch.get();
                    querySnapshot.docs.forEach(
                      (DocumentSnapshot document) {
                        Map<String, dynamic> results =
                            document.data() as Map<String, dynamic>;
                        resultsList.add(results);
                      },
                    );
                  } catch (error) {
                    print('Error querying data: $error');
                  }
                } else {
                  String date =
                      DateValidator.ValidateDate(queryDateController.text);
                  try {
                    QuerySnapshot querySnapshot =
                        await records.where('date', isEqualTo: date).get();
                    querySnapshot.docs.forEach((DocumentSnapshot document) {
                      Map<String, dynamic> results =
                          document.data() as Map<String, dynamic>;
                      resultsList.add(results);
                    });
                  } catch (error) {
                    print('Error querying data: $error');
                  }
                }
                _showQuery(resultsList, context);
              },
              child: const Text('Submit Query'),
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showQuery(
      List<Map<String, dynamic>> resultsList, BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Query Result'),
          content: SingleChildScrollView(
            child: Column(
              children: resultsList.isNotEmpty
                  ? resultsList.map((result) {
                      return ListTile(
                        title: Text(
                          result['title'],
                          style: const TextStyle(fontSize: 30),
                        ),
                        subtitle: Text(
                            'DATE: ${result['date']}\nTAGS: ${result['tag'].toString()}\nFROM: ${result['from']}\nTO: ${result['to']}'),
                      );
                    }).toList()
                  : [
                      const Text(
                        'No Results Found',
                        style: TextStyle(fontSize: 20),
                      )
                    ],
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
          ],
        );
      },
    );
  }
}
