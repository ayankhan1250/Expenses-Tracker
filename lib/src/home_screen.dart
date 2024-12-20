import 'package:expenses_tracker/widgets/my_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../class/bar_logic.dart';
import '../class/model.dart';

class ExpensesTracker extends StatefulWidget {
  const ExpensesTracker({super.key});

  @override
  State<ExpensesTracker> createState() => _ExpensesTrackerState();
}

class _ExpensesTrackerState extends State<ExpensesTracker> {
  List<ExpensesData> expList = [];
  DateTime? selectedDate;
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  bool pressed = false;
  int selectedIndex = -1;

  List<ExpensesData> get recentTransactions {
    return expList.where((e) {
      return e.dateTime.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  checkField() {
    if (_titleController.text.isNotEmpty &&
        _amountController.text.isNotEmpty &&
        selectedDate!=null) {
      return true;
    }
  }

  clearField() {
    _titleController.clear();
    _amountController.clear();
    _dateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    print('built');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.add),
          onPressed: (){
            _bottomSheet(context);
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text(
            "Personal Expenses",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          titleSpacing: 10,
          actions: [
            IconButton(
              onPressed: () {
                  _bottomSheet(context);
              },
              icon: const Icon(Icons.add),
              color: Colors.white,
            )
          ],
        ),
        body: Column(
          children: [
            Chart(
              resent: recentTransactions,
            ),
            expList.isEmpty?
            Center(
              child: Column(
                children: [
                  const Text(
                    'No Transaction Added Yet !',
                    style:
                    TextStyle(fontSize: 21, fontWeight: FontWeight.normal),
                  ),
                  Image.asset('assets/images/waiting.png',scale: 2,),

                ],
              ),
            ):
            ///else
            Expanded(
              child: ListView.builder(
                itemCount: expList.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    child: ListTile(

                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        //backgroundColor: colors[index],
                        child: FittedBox(
                          child: Text(expList[index].amount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              )),
                        ),
                      ),
                      title: Text(expList[index].title),
                      subtitle: Text(DateFormat('yMMMEd').format(expList[index].dateTime)),

                      trailing: Wrap(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                print('show bottom sheet');
                                selectedIndex = index;
                                _titleController.text = expList[selectedIndex].title;
                                _amountController.text = expList[selectedIndex].amount.toString();
                                _dateController.text = expList[selectedIndex].dateTime.toString();
                                selectedDate=expList[selectedIndex].dateTime;
                                _bottomSheet(context);
                                pressed = true;
                              });
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed:  () {
                              setState(() {
                                print('remove');
                                expList.removeAt(index);
                                pressed=false;
                                clearField();
                              });
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],),
                    ),
                  );
                },),
            ),

          ],
        ),
      ),
    );
  }

  /// Bottom Sheet

  void _bottomSheet(BuildContext context) {
    showModalBottomSheet(
        shape: const Border(),
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                MyTextField(
                  inputFormat: [FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),],
                  textController: _titleController,
                  textInputController: TextInputType.text,
                  label: 'Title',
                ).myTextField(),
                MyTextField(
                  label: 'Amount',
                  textController: _amountController,
                  textInputController: TextInputType.number,
                  inputFormat: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ).myTextField(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onTap: _showDatePicker,
                    controller: _dateController,
                    readOnly: true,
                    decoration:  InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),

                        ),
                        label:const Text('Date'),
                        filled: true,
                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      pressed ? editEntry() : addEntry();
                      clearField();
                      Navigator.pop(context);
                    },
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blue)),
                    child: Text(
                      pressed ? 'Update' : 'Add transaction',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  /// Date Picker

  void _showDatePicker() async {
    final DateTime weekDays = DateTime.now().subtract(const Duration(days: 6));
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: weekDays,
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        print('picked');
        selectedDate = pickedDate;
        _dateController.text = DateFormat('yMMMEd').format(selectedDate!);
      });
    }
  }

  addEntry() {
    if (checkField()==true) {
      setState(() {
        print('add');
        expList.add(
            ExpensesData(
              title: _titleController.text,
              amount: double.parse(_amountController.text),
              dateTime: selectedDate!,
            ));
      });
    }
  }

  editEntry() {
    if (checkField()==true) {
      setState(() {
        print('edit');
        expList[selectedIndex].title = _titleController.text;
        expList[selectedIndex].amount = double.parse(_amountController.text);
        expList[selectedIndex].dateTime = selectedDate!;
        pressed = false;
      });
    }

  }
}
