import 'package:flutter/material.dart';
import 'package:schedyoule/data/models/models.dart';
import 'package:schedyoule/views/course_list_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CourseListView();
  }
}
