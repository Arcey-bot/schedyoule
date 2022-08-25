import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:schedyoule/views/home_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: Tips screen or something idk
// TODO: Schedules get more fucked up the further down you scroll (Possibly fixed?)
// TODO: Save courses on exit

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
