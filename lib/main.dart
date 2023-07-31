import 'package:flutter/material.dart';
import './yolo.dart';

void main() {
  runApp(const MyYolo());
}

class MyYolo extends StatelessWidget {
  const MyYolo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: Center(
      child: FloatingActionButton(onPressed: () async {
        testYolov8();
      }),
    )));
  }
}
