import 'package:flutter/material.dart';

class SomeScreen extends StatelessWidget {
  const SomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        left: true,
        right: true,
        child: Center(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}