import 'package:Expenser/components/loader.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'components/addExpenditureAlertDialog.dart';
import 'components/editExpenditureAlertDialog.dart';

class DailyView extends StatefulWidget {
  @override
  _DailyViewState createState() => _DailyViewState();
}

class _DailyViewState extends State<DailyView> {
  DateTime currentDate = new DateTime.now();
  DateTime selectedDate = new DateTime.now();
  String selectedDateString = '';
  String currentDateString = '';
  List months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  bool isLoading = true;
  List expenseData = [];
  var _formKey = GlobalKey<FormState>();
  String type = '';
  double expense = 0.0;
  double totalExpense = 0.0;
  String username = '';

  InputDecoration formInputDecoration(labelText) {
    return InputDecoration(
      focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
      enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
      labelText: labelText,
      labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
    );
  }

  void getExpenseData() async {
    setState(() {
      isLoading = true;
    });
    var box = await Hive.openBox('expenseData');
    var userBox = await Hive.openBox('userData');
    username = userBox.get('name');
    currentDateString =
        '${currentDate.day}/${currentDate.month}/${currentDate.year}';
    selectedDateString =
        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';

    List tempExpenseDataByMonth =
        box.get('${months[selectedDate.month - 1]}${selectedDate.year}') ??
            []; //Mar2020

    List tempExpenseData = [];
    // print(box.values);
    tempExpenseDataByMonth.forEach((element) {
      if (element['date'] == selectedDateString) {
        tempExpenseData = element['expenses'];
      }
    });
    totalExpense = 0.0;
    tempExpenseData.forEach((element) {
      totalExpense += element['value'];
    });
    print(totalExpense);
    setState(() {
      isLoading = false;
      expenseData = tempExpenseData;
    });
  }

  void selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedDateString =
            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
      });
      getExpenseData();
    }
  }

  void _showAddExpenseDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return AddExpenditure(
          formKey: _formKey,
          months: months,
          selectedDate: selectedDate,
          expenseData: expenseData,
          selectedDateString: selectedDateString,
          updateData: (tempExpenseData, tempExpense) {
            setState(() {
              expenseData = tempExpenseData;
              totalExpense += tempExpense;
            });
          },
        );
      },
    );
  }

  void _showEditExpenseDialog(
    String expenditureType,
    double expenditureValue,
    int expenditureIndex,
    int expenditureTypeOfExpense,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog

        return EditExpenditure(
          formKey: _formKey,
          expenditureIndex: expenditureIndex,
          expenditureType: expenditureType,
          expenditureValue: expenditureValue,
          expenseData: expenseData,
          months: months,
          selectedDate: selectedDate,
          selectedDateString: selectedDateString,
          expenditureTypeOfExpense: expenditureTypeOfExpense,
          updateData: (editType, editExpense, editTypeOfExpense, editDate) {
            setState(() {
              expenseData[expenditureIndex] = {
                'name': editType,
                'value': editExpense,
                'type': editTypeOfExpense,
                'date': editDate,
              };
              totalExpense = totalExpense - expenditureValue + editExpense;
            });
          },
        );
      },
    );
  }

  void deleteExpenseData(
    String expenditureType,
    double expenditureValue,
    int expenditureIndex,
  ) async {
    var box = await Hive.openBox('expenseData');
    // box.clear();
    List prevExpensesData =
        box.get('${months[selectedDate.month - 1]}${selectedDate.year}') ??
            []; //Eg: Mar2020
    // List tempExpenseData = [];
    var removed = false;
    prevExpensesData.forEach((element) {
      if (element['date'] == selectedDateString) {
        if (!removed) {
          element['expenses'].removeAt(expenditureIndex);
          removed = true;
        }
      }
    });

    box.put(
      '${months[selectedDate.month - 1]}${selectedDate.year}',
      prevExpensesData,
    );
    print(expenditureIndex);

    setState(() {
      // expenseData.removeAt(expenditureIndex);
      totalExpense -= expenditureValue;
    });
  }

  String capitalize(String str) {
    return "${str[0].toUpperCase()}${str.substring(1).toLowerCase()}";
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

  @override
  void initState() {
    super.initState();
    getExpenseData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // box.clear();
          _showAddExpenseDialog();
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
        ),
        backgroundColor:
            Theme.of(context).floatingActionButtonTheme.backgroundColor,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: isLoading
          ? Loading()
          : Padding(
              padding: EdgeInsets.only(
                top: 30.0,
                left: 12.0,
                right: 12.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello,',
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      Text(
                        username,
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 2.0,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 170.0,
                    color: Theme.of(context).accentColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 21.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'You have spent,',
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Text(
                            '\u20B9' + addCommasToPrice(totalExpense),
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'on $selectedDateString',
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              IconButton(
                                onPressed: () => selectDate(context),
                                icon: Icon(
                                  Icons.calendar_today,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Transactions',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  expenseData.length == 0
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'No Transactions have been made today.',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              var expenses = expenseData[index];
                              double percentage =
                                  expenses['value'] / totalExpense * 100;
                              List iconList = [
                                Icons.shopping_cart,
                                Icons.home,
                                Icons.games,
                                Icons.restaurant,
                                Icons.bolt,
                                Icons.medical_services,
                                Icons.train,
                                Icons.computer,
                                Icons.home_repair_service,
                                Icons.monetization_on,
                              ];
                              return ListTile(
                                // tileColor: Theme.of(context).accentColor,
                                leading: Icon(
                                  iconList[expenses['type']],
                                  color: Theme.of(context).primaryColorLight,
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      expenses['name'],
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    Text(
                                      'Rs.' +
                                          addCommasToPrice(expenses['value']),
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                                subtitle: Text(
                                  '${percentage.toStringAsFixed(2)} %',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                trailing: PopupMenuButton(
                                  color: Theme.of(context).accentColor,
                                  elevation: 8.0,
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      // print('edit');
                                      _showEditExpenseDialog(
                                        expenseData[index]['name'],
                                        expenseData[index]['value'],
                                        index,
                                        expenseData[index]['type'],
                                      );
                                    } else if (value == 'delete') {
                                      // print('delete');
                                      deleteExpenseData(
                                        expenseData[index]['name'],
                                        expenseData[index]['value'],
                                        index,
                                      );
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Text(
                                        'Edit',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text(
                                        'Delete',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ),
                                  ],
                                  child: Icon(
                                    Icons.more_vert,
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                ),
                              );
                            },
                            itemCount: expenseData.length,
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}

// ListTile(
//                   title: RichText(
//                     text: TextSpan(
//                       style: TextStyle(
//                         color: Colors.amberAccent,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: 'Expenses On ',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w200,
//                           ),
//                         ),
//                         TextSpan(
//                           text:
//                               '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
//                         ),
//                       ],
//                     ),
//                   ),
//                   trailing: FlatButton(
//                     child: Text(
//                       "Change Date",
//                       style: TextStyle(
//                         color: Colors.grey[900],
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     color: Colors.amberAccent,
//                     onPressed: () => selectDate(context),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12.0,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Total,",
//                         style: TextStyle(
//                           color: Colors.amberAccent,
//                           fontSize: 20,
//                           fontWeight: FontWeight.w200,
//                         ),
//                       ),
//                       Text(
//                         'Rs.${totalExpense.toString()}',
//                         style: TextStyle(
//                           color: Colors.amberAccent,
//                           fontSize: 30,
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 expenseData.isEmpty
//                     ? Center(
//                         child: Text(
//                           'No Data Available On This Date',
//                           style: TextStyle(
//                             color: Colors.amberAccent,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       )
//                     : Expanded(
//                         child: ListView.builder(
//                           itemCount: expenseData.length,
//                           itemBuilder: (context, index) {
//                             double percentage = expenseData[index]['value'] /
//                                 totalExpense *
//                                 100;

//                             return ListTile(
//                               leading: Text(
//                                 '${percentage.toStringAsFixed(1)} %',
//                                 style: TextStyle(
//                                   color: Colors.amberAccent,
//                                 ),
//                               ),
//                               subtitle: Text(
//                                 'Rs.${expenseData[index]['value'].toString()}',
//                                 style: TextStyle(
//                                   color: Colors.amberAccent,
//                                 ),
//                               ),
//                               title: Text(
//                                 expenseData[index]['name'],
//                                 style: TextStyle(
//                                   color: Colors.amberAccent,
//                                 ),
//                               ),
//                               trailing: PopupMenuButton(
//                                 color: Colors.amberAccent,
//                                 elevation: 8.0,
//                                 onSelected: (value) {
//                                   if (value == 'edit') {
//                                     // print('edit');
//                                     _showEditExpenseDialog(
//                                       expenseData[index]['name'],
//                                       expenseData[index]['value'],
//                                       index,
//                                     );
//                                   } else if (value == 'delete') {
//                                     // print('delete');
//                                     deleteExpenseData(
//                                       expenseData[index]['name'],
//                                       expenseData[index]['value'],
//                                       index,
//                                     );
//                                   }
//                                 },
//                                 itemBuilder: (context) => [
//                                   PopupMenuItem(
//                                     value: 'edit',
//                                     child: Text(
//                                       'Edit',
//                                       style: TextStyle(
//                                         color: Colors.grey[900],
//                                       ),
//                                     ),
//                                   ),
//                                   PopupMenuItem(
//                                     value: 'delete',
//                                     child: Text(
//                                       'Delete',
//                                       style: TextStyle(
//                                         color: Colors.grey[900],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                                 child: Icon(
//                                   Icons.more_vert,
//                                   color: Colors.amberAccent,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
