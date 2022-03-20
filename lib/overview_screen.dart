import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'md_screen.dart';

class OverviewScreen extends StatelessWidget {
  final Map<String, dynamic> map;
  const OverviewScreen({Key? key, required this.map}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(map["name"]),
      ),
      body: SafeArea(child: FutureBuilder(future: getArticlesList(map["id"]),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<Map<String, dynamic>> articles =
                snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    articles[index]["name"],
                  ),
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MDScreen(
                          markDown: articles[index]["markdown"],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      )),
    );
  }
}

Future<List<Map<String, dynamic>>> getArticlesList(String id) async{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference widgets = firestore.collection("topics/" + id + "/articles");
  List<Map<String, dynamic>> result = List.empty(growable: true);
  var docs = (await widgets.get()).docs;
  for (var doc in docs) {
    var map = doc.data() as Map<String, dynamic>;
    result.add(map);
  }
  return result;
}
