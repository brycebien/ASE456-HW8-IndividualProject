import 'package:ase456_hw8_individual_project/components/date_input.dart';
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
            ],
          )),
    );
  }
}
