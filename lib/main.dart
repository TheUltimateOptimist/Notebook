import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:widgets/firebase_options.dart';
import 'package:widgets/overview_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notebook',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const MyHomePage(title: 'Notebook'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: getTopicsList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Map<String, dynamic>> topics = snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              itemCount: topics.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OverviewScreen(
                          map: topics[index],
                        ),
                      ),
                    );
                  },
                  title: Text(
                    topics[index]["name"],
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> getTopicsList() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference widgets = firestore.collection("topics");
  List<Map<String, dynamic>> result = List.empty(growable: true);
  var docs = (await widgets.get()).docs;
  for (var doc in docs) {
    var map = doc.data() as Map<String, dynamic>;
    map["id"] = doc.id;
    result.add(map);
  }
  return result;
}
