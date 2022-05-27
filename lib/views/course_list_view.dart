import 'package:flutter/material.dart';

// ListView with 1 empty course card initially.
// Every time a course card is filled in, add a new empty course card
// To the ListView, and rebuild

class CourseListView extends StatelessWidget {
  const CourseListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add your courses'),
      ),
      body: Container(color: Colors.pink),
    );
  }
}
