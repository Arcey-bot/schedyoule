import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedyoule/views/home_view.dart';

// TODO: Tips screen or something idk
// TODO: Opened/Closed schedules do not maintain state when offscreen
// TODO: Schedules get more fucked up the further down you scroll (Possibly fixed?)
// TODO: Update animation (Entire card is no longer being rebuilt)

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
