import 'package:flutter/material.dart';
import 'package:take_notes/models/finance_database.dart';
import 'package:take_notes/widgets/expense_card.dart';

class ExpenseList extends StatefulWidget {
  final args;
  ExpenseList(this.args);
  @override
  _ExpenseList createState() => _ExpenseList();
}

/*
* Read all expenses stored in database and sort them based on name 
*/
Future<List<Map<String, dynamic>>> readDatabase(monthYear) async {
  try {
    FinanceDatabase dbConn = FinanceDatabase();
    await dbConn.initDatabase();
    List<Map> expenseList = await dbConn.getAllFinanceByMonthYear(monthYear);
    //await notesDb.deleteAllNotes();
    await dbConn.closeDatabase();
    List<Map<String, dynamic>> expensesData =
        List<Map<String, dynamic>>.from(expenseList);
    print(expensesData);
    expensesData.sort((a, b) => (b['id']).compareTo(a['id']));
    return expensesData;
  } catch (e) {
    print(e);
    return [];
  }
}

class _ExpenseList extends State<ExpenseList> {
  List<int> selectedIds = [];
  List<Map<String, dynamic>> expenseData = [];

  @override
  void initState() {
    super.initState();
  }

  // Render the screen and update changes
  void afterNavigatorPop() {
    setState(() {});
  }

  // To handel back button
  void handleBackButton() {
    Navigator.pop(context);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => handleBackButton(),
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text(widget.args[0] + ' Expenses'),
        backgroundColor: Color.fromARGB(255, 187, 47, 42),
      ),
      floatingActionButton: (selectedIds.isEmpty
          ? FloatingActionButton(
              tooltip: 'New Finance',
              backgroundColor: const Color.fromARGB(255, 218, 8, 8),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/finance_edit',
                  arguments: [
                    'new',
                    [{}],
                  ],
                ).then((dynamic value) {
                  afterNavigatorPop();
                });
              },
              child: const Icon(
                Icons.add,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            )
          : null),
      body: FutureBuilder(
          future: readDatabase(widget.args[0]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              expenseData = snapshot.data ?? [];
              return Container(
                margin: const EdgeInsets.only(top: 10),
                child: Stack(
                  children: <Widget>[
                    // Display Notes
                    ListView.builder(
                        itemCount: expenseData.length,
                        itemBuilder: (context, index) {
                          dynamic item = expenseData[index];
                          return DisplayExpenses(item, afterNavigatorPop);
                        }),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error found'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                ),
              );
            }
          }),
    );
  }
}
