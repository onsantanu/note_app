import 'package:flutter/material.dart';
import 'package:take_notes/models/finance_database.dart';
import 'package:take_notes/widgets/expence_summary.dart';

class Finance extends StatefulWidget {
  @override
  _Finance createState() => _Finance();
}

/*
* Read all expenses stored in database and sort them based on name 
*/
Future<List<Map<String, dynamic>>> readDatabase() async {
  try {
    FinanceDatabase dbConn = FinanceDatabase();
    await dbConn.initDatabase();
    List<Map> expenseList = await dbConn.getAllFinance();
    //await notesDb.deleteAllNotes();
    await dbConn.closeDatabase();
    List<Map<String, dynamic>> expensesData =
        List<Map<String, dynamic>>.from(expenseList);
    expensesData.sort((a, b) => (b['monthyear']).compareTo(a['monthyear']));
    return expensesData;
  } catch (e) {
    print(e);
    return [];
  }
}

class _Finance extends State<Finance> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.currency_rupee),
        title: const Text('Finance'),
        backgroundColor: Color.fromARGB(255, 187, 47, 42),
      ),
      floatingActionButton: (selectedIds.isEmpty
          ? FloatingActionButton(
              tooltip: 'New Finance',
              backgroundColor: Color.fromARGB(255, 196, 34, 34),
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
                return;
              },
              child: const Icon(
                Icons.add,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            )
          : null),
      body: FutureBuilder(
          future: readDatabase(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              expenseData = snapshot.data ?? [];
              return Container(
                margin: const EdgeInsets.only(top: 10),
                child: Stack(
                  children: <Widget>[
                    // Display Notes
                    expenseData.isNotEmpty
                        ? ListView.builder(
                            itemCount: expenseData.length,
                            itemBuilder: (context, index) {
                              dynamic item = expenseData[index];
                              return DisplaySummaryExpenses(
                                  item, afterNavigatorPop);
                            })
                        : const Center(
                            child: Icon(Icons.hourglass_empty_rounded,
                                color: Color.fromARGB(255, 15, 122, 117),
                                size: 200),
                          ),
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
