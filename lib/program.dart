import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyB6MdKv9JfU7ekn5cfMa4rZ86pgXzm6o5o",
          appId: "1:959433885237:web:34d75e37213b1f0f50537c",
          messagingSenderId: "959433885237",
          projectId: "ase456-d8dbe"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prototype',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Time Management (Prototype)'),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Dialog box'),
                      content: TextField(
                        controller: _textEditingController,
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                            onPressed: () {
                              String enteredText = _textEditingController.text;
                              print('Entered Text: $enteredText');
                              Navigator.of(context).pop();
                            },
                            child: const Text('Submit'))
                      ],
                    );
                  },
                );
              },
              child: const Text('Show dialog box'),
            ),
            Text('this is the entered text'),
          ],
        ),
      ),
    );
  }
}
