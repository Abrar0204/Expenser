import 'package:Expenser/components/loader.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  var name = '';
  var income = 0.0;
  bool isLoading = true;
  var _formKey = GlobalKey<FormState>();
  void getData() async {
    setState(() {
      isLoading = true;
    });
    var userBox = await Hive.openBox('userData');
    name = userBox.get('name') ?? '';
    income = userBox.get('salary') ?? 0.0;
    setState(() {
      isLoading = false;
    });
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).accentColor,
          title: Text(
            'Delete Expenses',
            style: Theme.of(context).textTheme.headline5,
          ),
          content: Text(
            'This will delete all your expense data.',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              color: Theme.of(context).buttonColor,
            ),
            FlatButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  var expenseBox = await Hive.openBox('expenseData');
                  expenseBox.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Delete',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              color: Theme.of(context).errorColor,
            ),
          ],
        );
      },
    );
  }

  String addCommasToPrice(double price) {
    var priceString = price.toStringAsFixed(0);
    if (priceString.length == 4) {
      return ('${priceString[0]}' + ',${priceString.substring(1)}');
    } else if (priceString.length == 5) {
      return ('${priceString.substring(0, 2)}' +
          ',${priceString.substring(2)}');
    } else if (priceString.length == 6) {
      return ('${priceString.substring(0, 3)}' +
          ',${priceString.substring(3)}');
    } else {
      return (priceString);
    }
  }

  InputDecoration formInputDecoration(labelText) {
    return InputDecoration(
      focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
      enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
      labelText: labelText,
      labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void _showEditDialog(BuildContext context, String name, String value) {
    var editValue = value;
    showDialog(
      context: context,
      builder: (context) {
        final node = FocusScope.of(context);
        return AlertDialog(
          backgroundColor: Theme.of(context).accentColor,
          title: Text(
            'Edit $name',
            style: Theme.of(context).textTheme.headline5,
          ),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: value.toString(),
                  onEditingComplete: () => node.nextFocus(),
                  onChanged: (val) {
                    editValue = val;
                  },
                  // ignore: missing_return
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter $name';
                    }
                  },
                  textCapitalization: TextCapitalization.sentences,
                  cursorColor: Theme.of(context).primaryColorLight,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: formInputDecoration(name),
                ),
              ],
            ),
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              color: Theme.of(context).accentColor,
            ),
            FlatButton(
              onPressed: () async {
                var userBox = await Hive.openBox('userData');
                if (name == 'Expense') {
                  userBox.put('salary', double.parse(editValue));
                } else {
                  userBox.put('name', editValue);
                }
                setState(() {
                  getData();
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'Save',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              color: Theme.of(context).buttonColor,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: isLoading
          ? Loading()
          : Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 15.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'User Details',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Name',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Row(
                          children: [
                            Text(
                              name,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Theme.of(context).primaryColorLight,
                                size: 18,
                              ),
                              onPressed: () {
                                _showEditDialog(
                                  context,
                                  'Name',
                                  name,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Income',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Row(
                          children: [
                            Text(
                              '\u20B9${addCommasToPrice(income)}',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Theme.of(context).primaryColorLight,
                                size: 18,
                              ),
                              onPressed: () {
                                _showEditDialog(
                                  context,
                                  'Expense',
                                  income.toString(),
                                );
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FlatButton(
                        onPressed: () async {
                          _showDeleteDialog(context);
                        },
                        child: Text(
                          'Clear Expense Data',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        color: Theme.of(context).errorColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
