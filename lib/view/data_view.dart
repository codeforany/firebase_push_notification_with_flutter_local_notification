
import 'dart:convert';

import 'package:flutter/material.dart';

class DataView extends StatefulWidget {
  final Map nObj;
  const DataView({super.key, required this.nObj});

  @override
  State<DataView> createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Data View"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Text( json.encode( widget.nObj) ),
      ),
    );
  }
}