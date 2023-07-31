import 'package:flutter/material.dart';

import 'routes/route_generator.dart';

void main() async {
  runApp(AppEntry());
}

class AppEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: GenerateAllRoutes.generateRoute,
    );
  }
}
