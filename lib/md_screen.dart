import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class MDScreen extends StatelessWidget {
  final String markDown;
  const MDScreen({required this.markDown, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(child:
       Markdown(data: markDown, selectable: true, onTapLink: (linkName,url,_) async{
         if(url != null){
           await launch(url);
         }
       },),
      
        
      ),
    );
  }
}
