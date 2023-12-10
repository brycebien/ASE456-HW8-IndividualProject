import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Priority extends StatelessWidget {
  final FirebaseFirestore fireStore;
  Priority({super.key, required this.fireStore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(
          child: Text('All Activities (longest-shortest)'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<dynamic>(
            future: priority(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error:${snapshot.error}');
              } else {
                return snapshot.data ?? Text('No Data Available');
              }
            },
          ),
        ),
      ),
    );
  }

  priority() async {
    QuerySnapshot querySnapshot = await fireStore.collection('records').get();
    List<Map<String, dynamic>> dataList = [];
    querySnapshot.docs.forEach(
      (DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        dataList.add(data);
      },
    );

    dataList.forEach((data) {
      DateTime from = DateFormat('h:mm a').parse(data['from']);
      DateTime to = DateFormat('h:mm a').parse(data['to']);
      Duration timeTaken = to.difference(from);

      // Add a new key-value pair 'timeTaken' to each map
      data['timeTaken'] = timeTaken.inMinutes.toString();
    });

    dataList.sort((a, b) {
      DateTime fromA = DateFormat('h:mm a').parse(a['from']);
      DateTime toA = DateFormat('h:mm a').parse(a['to']);
      Duration durationA = toA.difference(fromA);

      DateTime fromB = DateFormat('h:mm a').parse(b['from']);
      DateTime toB = DateFormat('h:mm a').parse(b['to']);
      Duration durationB = toB.difference(fromB);

      return durationB.compareTo(durationA);
    });

    return SingleChildScrollView(
      child: Column(
          children: dataList.map((data) {
        return ListTile(
          title: Text(
            'Task: ${data['title']}',
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Time Taken: ${data['timeTaken']} minutes',
            style: const TextStyle(fontSize: 20),
          ),
        );
      }).toList()),
    );
  }
}
