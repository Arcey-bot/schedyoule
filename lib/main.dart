import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedyoule/views/home_view.dart';

// TODO: Tips screen or something idk
// TODO: When changing focus to time button from typing name, name is not saved
// TODO: Courses should not reorder when modified
// TODO: Courses updating incorrectly when a different course is modified
// TODO: Add deadspace at bottom of course screen so FAB doesn't obscure time selector
// TODO: Perhaps show card times in 24hr format
// TODO: Opened/Closed schedules do not maintain state when offscreen

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeView(),
    );
  }
}
