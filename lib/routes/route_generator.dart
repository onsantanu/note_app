import 'package:flutter/material.dart';

import 'package:take_notes/screens/home.dart';
import 'package:take_notes/screens/notes_edit.dart';
import 'package:take_notes/screens/landing.dart';
import 'package:take_notes/screens/finance.dart';
import 'package:take_notes/screens/finance_dtl.dart';
import 'package:take_notes/screens/expenses_list.dart';

class GenerateAllRoutes {
  static Route<dynamic> generateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => LandingPage());
      case '/notes_edit':
        return MaterialPageRoute(
            builder: (context) => NotesEdit(settings.arguments));
      case '/finance':
        return MaterialPageRoute(builder: (context) => Finance());
      case '/finance_edit':
        return MaterialPageRoute(
            builder: (context) => FinanceDetails(settings.arguments));
      case '/expense_list':
        return MaterialPageRoute(
            builder: (context) => ExpenseList(settings.arguments));
      default:
        return _unknownRoute();
    }
  }
}

Route<dynamic> _unknownRoute() {
  return MaterialPageRoute(builder: (context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oops!'),
      ),
      body: const Center(
        child: Text('Page not found'),
      ),
    );
  });
}
