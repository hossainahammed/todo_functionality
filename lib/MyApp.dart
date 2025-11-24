import 'package:flutter/material.dart';

import 'TODOAPP_Functionality.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TODOAPP_Functionality(),
    );
  }
}
