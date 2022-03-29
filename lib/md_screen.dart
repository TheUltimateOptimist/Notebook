import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class MDScreen extends StatelessWidget {
  final String markDown;
  const MDScreen({required this.markDown, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Markdown(
          data: markDown,
          selectable: true,
          onTapLink: (linkName, url, _) async {
            if (url == null) return;
            if (!url.startsWith("http")) {
              String destinationMarkdown = await getArticleMarkdown(url);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MDScreen(
                    markDown: destinationMarkdown,
                  ),
                ),
              );
            } 
            else await launch(url);
          },
        ),
      ),
    );
  }

  Future<String> getArticleMarkdown(String docPath) async{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentReference docRef = firestore.doc(docPath);
  Map<String, dynamic> docData = (await docRef.get()).data() as Map<String, dynamic>;
  return docData["markdown"];
}
}
