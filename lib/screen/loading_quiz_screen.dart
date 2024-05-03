import 'package:flutter/material.dart';

class LoadingQuizScreen extends StatefulWidget {
  const LoadingQuizScreen({super.key});

  @override
  State<LoadingQuizScreen> createState() => _LoadingQuizScreenState();
}

class _LoadingQuizScreenState extends State<LoadingQuizScreen> {
  @override
  Widget build(BuildContext context) {
    return const Text("되는중 ㅋ");
  }
}
