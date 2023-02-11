import 'package:flutter/material.dart';

class Director extends StatefulWidget {
  final String? channalName;
  const Director({super.key, this.channalName});

  @override
  State<Director> createState() => _DirectorState();
}

class _DirectorState extends State<Director> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('director'),
      ),
    );
  }
}
