import 'dart:html';

import 'package:ase456_hw8_individual_project/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Management Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Time Management Application'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var tagsController = TextEditingController();
  var startTimeController = TextEditingController();
  var endTimeController = TextEditingController();
  var queryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          //TASK
          const Text('Input a task:'),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Enter a task title'),
          ),
          const SizedBox(
            height: 16,
          ),

          //DATE
          const Text('Task Date:'),
          TextField(
            controller: dateController,
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (selectedDate != null) {
                dateController.text =
                    selectedDate.toLocal().toString().split(' ')[0];
              }
            },
            decoration: const InputDecoration(hintText: 'Select task date'),
          ),
          const SizedBox(height: 16),

          //START TIME
          const Text('Start Time:'),
          TextField(
            controller: startTimeController,
            onTap: () async {
              TimeOfDay? selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (selectedTime != null) {
                startTimeController.text = selectedTime.format(context);
              }
            },
            decoration: const InputDecoration(hintText: 'Select start time'),
          ),
          const SizedBox(height: 16),

          //END TIME
          const Text('End Time:'),
          TextField(
            controller: endTimeController,
            onTap: () async {
              TimeOfDay? selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (selectedTime != null) {
                endTimeController.text = selectedTime.format(context);
              }
            },
            decoration: const InputDecoration(hintText: 'Select end time'),
          ),
          const SizedBox(height: 16),

          //TAG
          const Text('Tag:'),
          TextField(
            controller: tagsController,
            decoration:
                const InputDecoration(hintText: 'Enter tags (comma-separated)'),
          ),
          const SizedBox(height: 16),

          //INPUT BUTTON
          ElevatedButton(
            onPressed: () {
              //Map data to JSON
              Map<String, dynamic> data = {
                'title': titleController.text,
                'date': dateController.text,
                'from': startTimeController.text,
                'to': endTimeController.text,
                'tag': tagsController.text
              };
              //input data to db
              _firestore.collection('records').doc().set(data).then((value) {
                print('Task added successfully!');
              }).catchError((error) {
                print('Error adding task $error');
              });
            },
            child: const Text('Submit Record'),
          ),
          const SizedBox(height: 25),

          //QUERY
          TextField(
            controller: queryController,
            decoration: const InputDecoration(hintText: 'input a query'),
          ),
          const SizedBox(height: 16),
          //QUERY INPUT BUTTON
          ElevatedButton(
            onPressed: () async {
              //TODO: query from database based on query
              //query events from current day if query == 'today'
              if (queryController.text == 'today') {
                String date = DateTime.now().toLocal().toString().split(' ')[0];

                CollectionReference records = _firestore.collection('records');

                try {
                  //query db
                  QuerySnapshot querySnapshot =
                      await records.where('date', isEqualTo: date).get();

                  //iterating through query results
                  querySnapshot.docs.forEach((DocumentSnapshot document) {
                    print(document.data());
                  });
                } catch (error) {
                  print('Error querying data: $error');
                }
              }
            },
            child: const Text('Submit Query'),
          )
        ],
      ),
    );
  }
}
