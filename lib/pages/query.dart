import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QueryRecord extends StatelessWidget {
  var queryController = TextEditingController();
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
            TextField(
              controller: queryController,
              decoration: const InputDecoration(hintText: 'Input a query'),
            ),
            const SizedBox(height: 16),
            //QUERY INPUT BUTTON
            ElevatedButton(
              onPressed: () async {
                //query events from current day if query == 'today'
                if (queryController.text == 'today') {
                  String date =
                      DateTime.now().toLocal().toString().split(' ')[0];

                  CollectionReference records = fireStore.collection('records');

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
      ),
    );
  }
}
 //QUERY
            