 //QUERY
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