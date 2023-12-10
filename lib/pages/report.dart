// ignore_for_file: use_build_context_synchronously

import 'package:ase456_hw8_individual_project/components/date_input.dart';
import 'package:ase456_hw8_individual_project/components/show_snackbar.dart';
import 'package:ase456_hw8_individual_project/utility/query_report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Report extends StatelessWidget {
  final FirebaseFirestore fireStore;
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  Report({super.key, required this.fireStore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(
          child: Text('Record an Activity'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Input a Start Date'),
            DateInput(
                controller: startDateController,
                context: context,
                hintText: 'Start Date'),
            const SizedBox(height: 16),
            const Text('Input an End Date'),
            DateInput(
                controller: endDateController,
                context: context,
                hintText: 'End Date'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                List<Map<String, dynamic>>? results = await QueryReport(
                  fireStore: fireStore,
                  startDate: startDateController.text,
                  endDate: endDateController.text,
                ).queryRecord();
                results != null
                    ? _showQuery(results, context)
                    : ShowSnackBar(
                        content: 'No Results Found',
                        duration: 3,
                        context: context);
              },
              child: const Text('Generate Report'),
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
