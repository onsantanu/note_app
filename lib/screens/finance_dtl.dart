import 'package:flutter/material.dart';
import 'package:take_notes/models/daily_finance_model.dart';
import 'package:take_notes/widgets/toaster.dart';
import 'package:take_notes/models/finance_database.dart';

class FinanceDetails extends StatefulWidget {
  final args;
  const FinanceDetails(this.args);
  @override
  _FinanceDetails createState() => _FinanceDetails();
}

class _FinanceDetails extends State<FinanceDetails> {
  List<int> selectedIds = [];
  String title = '';
  String content = '';
  double amount = 0.0;
  DateTime createdat = DateTime.now();

  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _contentTextController = TextEditingController();
  TextEditingController _amountTextController = TextEditingController();
  TextEditingController _dateInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    title = (widget.args[0] == 'new' ? '' : widget.args[1]['title']);
    content = (widget.args[0] == 'new' ? '' : widget.args[1]['content']);
    amount = (widget.args[0] == 'new' ? 0.0 : widget.args[1]['amount']);

    _titleTextController.text =
        (widget.args[0] == 'new' ? '' : widget.args[1]['title']);
    _contentTextController.text =
        (widget.args[0] == 'new' ? '' : widget.args[1]['content']);
    _amountTextController.text =
        (widget.args[0] == 'new' ? '' : widget.args[1]['amount'].toString());
    _dateInputController.text = (widget.args[0] == 'new'
        ? createdat.toString().split(' ')[0]
        : widget.args[1]['createdat']);
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

  Future<void> _insertNote(DailyFinance obj) async {
    FinanceDatabase notesDb = FinanceDatabase();
    await notesDb.initDatabase();
    int result = await notesDb.insertFinance(obj);
    await notesDb.closeDatabase();
  }

  Future<void> _updateNote(DailyFinance obj) async {
    FinanceDatabase notesDb = FinanceDatabase();
    await notesDb.initDatabase();
    int result = await notesDb.updateFinance(obj);
    await notesDb.closeDatabase();
  }

  void addExpenses() async {
    var flag = 0;
    if (_titleTextController.text.trim() == '') {
      showCustomToast('Enter the title');
      flag = 1;
    }

    if (_amountTextController.text.trim() == '') {
      showCustomToast('Enter the amount');
      flag = 1;
    }
    if (flag == 0) {
      title = _titleTextController.text;
      content = _contentTextController.text;
      amount = double.parse(_amountTextController.text);
      if (widget.args[0] == 'new') {
        DailyFinance newObj = DailyFinance(
            title: title,
            content: content,
            amount: amount,
            createdat: _dateInputController.text);
        try {
          await _insertNote(newObj);
          showCustomToast('Expense added successfully.');
          handleBackButton();
        } catch (e) {
          print(e);
        } finally {
          // Navigator.pop(context);
          return;
        }
      } else {
        DailyFinance newObj = DailyFinance(
            id: widget.args[1]['id'],
            title: title,
            content: content,
            amount: amount,
            createdat: _dateInputController.text);
        try {
          await _updateNote(newObj);
          showCustomToast('Expense details updated successfully.');
          handleBackButton();
        } catch (e) {
          print(e);
        } finally {
          // Navigator.pop(context);
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        handleBackButton();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              tooltip: 'Back',
              onPressed: () => handleBackButton(),
            ),
            title: const Text('Expense Details'),
            backgroundColor: Color.fromARGB(255, 187, 47, 42),
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  controller: _dateInputController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Select date',
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(DateTime.now().year + 2));

                    if (pickedDate != null) {
                      _dateInputController.text =
                          pickedDate.toString().split(' ')[0];
                    }
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  controller: _titleTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter the title',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  controller: _contentTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a description',
                  ),
                  minLines:
                      6, // any number you need (It works as the rows for the textarea)
                  maxLines: 8,
                  keyboardType: TextInputType.multiline,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextField(
                  controller: _amountTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter the amount',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(),
                    onPressed: () => addExpenses(),
                    child: const Text('Submit'),
                  )),
            ]),
          )),
    );
  }
}
