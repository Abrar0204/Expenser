import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class EditExpenditure extends StatefulWidget {
  const EditExpenditure({
    Key key,
    GlobalKey<FormState> formKey,
    this.months,
    this.selectedDate,
    this.expenseData,
    this.selectedDateString,
    this.updateData,
    this.expenditureType,
    this.expenditureValue,
    this.expenditureIndex,
    this.expenditureTypeOfExpense,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;

  final List months;
  final DateTime selectedDate;
  final List expenseData;
  final String selectedDateString;
  final Function updateData;
  final String expenditureType;
  final int expenditureTypeOfExpense;
  final double expenditureValue;
  final int expenditureIndex;

  @override
  _EditExpenditureState createState() => _EditExpenditureState();
}

class _EditExpenditureState extends State<EditExpenditure> {
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
  var editType = '';
  var editExpense = 0.0;
  @override
  void initState() {
    super.initState();
    editType = widget.expenditureType;
    editExpense = widget.expenditureValue;
    selectedType = widget.expenditureTypeOfExpense;
  }

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
        "Edit Expenditure",
        style: Theme.of(context).textTheme.headline5,
      ),
      content: Form(
        key: widget._formKey,
        child: Column(
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
              initialValue: widget.expenditureType,
              onEditingComplete: () => node.nextFocus(),
              onChanged: (val) {
                editType = val;
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
              decoration: formInputDecoration('Expenditure Type'),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: widget.expenditureValue.toStringAsFixed(0),
              onFieldSubmitted: (_) => node.unfocus(),
              onChanged: (val) {
                editExpense = double.parse(val);
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
          child: new Text(
            "Cancel",
            style: TextStyle(
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          color: Theme.of(context).buttonColor,
        ),
        FlatButton(
          color: Theme.of(context).buttonColor,
          child: new Text(
            "Save",
            style: TextStyle(
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          onPressed: () async {
            if (widget._formKey.currentState.validate()) {
              var box = await Hive.openBox('expenseData');
              editType = capitalize(editType);
              List prevExpensesData = box.get(
                      '${widget.months[widget.selectedDate.month - 1]}${widget.selectedDate.year}') ??
                  []; //Eg: Mar2020
              // List tempExpenseData = [];
              var edited = false;
              prevExpensesData.forEach((element) {
                // print(element);
                if (element['date'] == widget.selectedDateString) {
                  if (!edited) {
                    print(
                        widget.selectedDate.millisecondsSinceEpoch.toString());
                    element['expenses'][widget.expenditureIndex] = {
                      'name': editType,
                      'value': editExpense,
                      'type': selectedType,
                      'date':
                          widget.selectedDate.millisecondsSinceEpoch.toString(),
                    };
                    print(element['expenses'][widget.expenditureIndex]);
                    edited = true;
                  }
                }
              });
              // print(prevExpensesData);
              box.put(
                '${widget.months[widget.selectedDate.month - 1]}${widget.selectedDate.year}',
                prevExpensesData,
              );

              print(box.get(
                  '${widget.months[widget.selectedDate.month - 1]}${widget.selectedDate.year}')[1]);

              widget.updateData(
                editType,
                editExpense,
                selectedType,
                widget.selectedDate.millisecondsSinceEpoch.toString(),
              );

              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
