import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class AddExpenditure extends StatefulWidget {
  const AddExpenditure({
    Key key,
    GlobalKey<FormState> formKey,
    this.months,
    this.selectedDate,
    this.expenseData,
    this.selectedDateString,
    this.updateData,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;

  final List months;
  final DateTime selectedDate;
  final List expenseData;
  final String selectedDateString;
  final Function updateData;

  @override
  _AddExpenditureState createState() => _AddExpenditureState();
}

class _AddExpenditureState extends State<AddExpenditure> {
  String capitalize(String str) {
    return "${str[0].toUpperCase()}${str.substring(1).toLowerCase()}";
  }

  InputDecoration formInputDecoration(labelText) {
    return InputDecoration(
      focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
      enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
      labelText: labelText,
      labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
    );
  }

  var type = '';
  var expense = 0.0;
  var selectedType = 0;

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    List<DropdownMenuItem> typeList = [
      DropdownMenuItem(
        child: Text(
          'Groceries',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        value: 0,
      ),
      DropdownMenuItem(
        child: Text(
          'Rent',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        value: 1,
      ),
      DropdownMenuItem(
        child: Text(
          'Entertainment/Games',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        value: 2,
      ),
      DropdownMenuItem(
        child: Text(
          'Food/Restaurant',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        value: 3,
      ),
      DropdownMenuItem(
        child: Text(
          'Electricity',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        value: 4,
      ),
      DropdownMenuItem(
        child: Text(
          'Health/Medical',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        value: 5,
      ),
      DropdownMenuItem(
        child: Text(
          'Travel',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        value: 6,
      ),
      DropdownMenuItem(
        child: Text(
          'Electronics',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        value: 7,
      ),
      DropdownMenuItem(
        child: Text(
          'Services',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        value: 8,
      ),
      DropdownMenuItem(
        child: Text(
          'Other',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        value: 9,
      ),
    ];

    return AlertDialog(
      backgroundColor: Theme.of(context).accentColor,
      title: Text(
        "Add a Expenditure",
        style: Theme.of(context).textTheme.headline5,
      ),
      content: Form(
        key: widget._formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField(
              decoration: formInputDecoration('Expenditure Type'),
              isExpanded: true,
              dropdownColor: Theme.of(context).primaryColor,
              items: typeList,
              iconEnabledColor: Theme.of(context).primaryColorLight,
              elevation: 0,
              onChanged: (value) {
                // print(value);
                setState(() {
                  selectedType = value;
                });
              },
              value: selectedType,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              onEditingComplete: () => node.nextFocus(),
              onChanged: (val) {
                type = val;
              },
              // ignore: missing_return
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter name of expenditure';
                }
              },
              textCapitalization: TextCapitalization.sentences,
              cursorColor: Theme.of(context).primaryColorLight,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: formInputDecoration('Expenditure Name'),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              onFieldSubmitted: (_) => node.unfocus(),
              onChanged: (val) {
                expense = double.parse(val);
              },
              // ignore: missing_return
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter a Amount';
                } else if (!(double.parse(value) is double)) {
                  return 'Enter a Number';
                }
              },

              cursorColor: Theme.of(context).primaryColorLight,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: formInputDecoration('Amount in Rupees'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Theme.of(context).accentColor,
          child: Text(
            'Cancel',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        FlatButton(
          color: Theme.of(context).buttonColor,
          child: new Text(
            "Add",
            style: TextStyle(
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          onPressed: () async {
            if (widget._formKey.currentState.validate()) {
              var box = await Hive.openBox('expenseData');
              type = capitalize(type);
              List prevExpensesData = box.get(
                      '${widget.months[widget.selectedDate.month - 1]}${widget.selectedDate.year}') ??
                  []; //Eg: Mar2020
              var breakBool = false;
              var dateIsNotCreated = true;
              // print('Hey');
              var tempExpenseData = widget.expenseData;
              //check if date is present
              prevExpensesData.forEach((element) {
                if (element['date'] == widget.selectedDateString) {
                  if (!breakBool) {
                    dateIsNotCreated = false;
                    breakBool = true;
                  }
                }
              });
              // print(dateIsNotCreated);
              if (prevExpensesData.isEmpty || dateIsNotCreated) {
                print('Hello');
                prevExpensesData.add(
                  {
                    'date': widget.selectedDateString,
                    'expenses': [
                      {
                        'name': type,
                        'value': expense,
                        'type': selectedType,
                        'date': widget.selectedDate.millisecondsSinceEpoch
                            .toString(),
                      }
                    ],
                  },
                );
                tempExpenseData = [
                  {
                    'name': type,
                    'value': expense,
                    'type': selectedType,
                    'date':
                        widget.selectedDate.millisecondsSinceEpoch.toString(),
                  },
                ];
                print('tempData');
                print(tempExpenseData);
              } else {
                //add the expense data to the date only once
                print('There');
                var written = false;
                prevExpensesData.forEach((element) {
                  // print(element['date']);
                  if (element['date'] == widget.selectedDateString) {
                    if (!written) {
                      // print(written);
                      element['expenses'].add(
                        {
                          'name': type,
                          'value': expense,
                          'type': selectedType,
                          'date': widget.selectedDate.millisecondsSinceEpoch
                              .toString(),
                        },
                      );
                      tempExpenseData = element['expenses'];
                      written = true;
                    }
                  }
                });
              }
              // print('Before');
              // print(prevExpensesData);
              box.put(
                '${widget.months[widget.selectedDate.month - 1]}${widget.selectedDate.year}',
                prevExpensesData,
              );
              // print('After');
              // print(prevExpensesData);
              // print(box.get(
              // '${months[selectedDate.month - 1]}${selectedDate.year}'));
              // print(expenseData);
              widget.updateData(tempExpenseData, expense);

              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
