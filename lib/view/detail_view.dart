
import 'dart:convert';

import 'package:flutter/material.dart';

class DetailView extends StatefulWidget {
  final Map nObj;
  const DetailView({super.key, required this.nObj});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Detail View"),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Text( json.encode( widget.nObj) ),
      ),
    );
  }
}