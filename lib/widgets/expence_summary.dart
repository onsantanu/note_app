import 'package:flutter/material.dart';

// A Note view showing title, first line of note and color
class DisplaySummaryExpenses extends StatelessWidget {
  final expenseData;
  final afterNavigatorPop;
  final months = [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  DisplaySummaryExpenses(this.expenseData, this.afterNavigatorPop);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Material(
        elevation: 1,
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/expense_list',
              arguments: [
                expenseData['monthyear'],
              ],
            ).then((dynamic value) {
              afterNavigatorPop();
            });
            return;
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            // decoration:
            // const BoxDecoration(color: Color.fromARGB(255, 49, 149, 199)),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            expenseData['month'] ?? '',
                            style: const TextStyle(
                              fontSize: 21,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '${months[int.parse(expenseData['month'])]}-' +
                            expenseData['year'],
                        style: const TextStyle(fontSize: 18),
                      ),
                      Container(
                        height: 3,
                      ),
                      Text(
                        "₹ ${expenseData['totalAmount']}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
