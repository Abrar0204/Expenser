import 'components/loader.dart';
import 'package:flutter/material.dart';

class ExpenseTracker extends StatefulWidget {
  final Map expenseData;
  ExpenseTracker({this.expenseData});
  @override
  _ExpenseTrackerState createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  bool isLoading = true;
  List expenseList = [];
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
  IconData icon = Icons.monetization_on;
  void getData() {
    setState(() {
      icon = iconList[widget.expenseData['type']];
      expenseList = widget.expenseData['expenses'];
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.expenseData['name'],
            style: TextStyle(
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: isLoading
            ? Loading()
            : ListView.builder(
                itemBuilder: (context, index) {
                  var expenseData = expenseList[index];
                  Map prevExpenseData = {};
                  DateTime prevExpenseDate =
                      DateTime.fromMillisecondsSinceEpoch(1);
                  print(prevExpenseDate.year);
                  if (index != 0) {
                    prevExpenseData = expenseList[index - 1];
                    prevExpenseDate = DateTime.fromMillisecondsSinceEpoch(
                        int.parse(prevExpenseData['date']));
                  }
                  print(expenseData);
                  var date = DateTime.fromMillisecondsSinceEpoch(
                      int.parse(expenseData['date']));

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if ((prevExpenseDate.day != date.day &&
                                prevExpenseDate.month == date.month &&
                                prevExpenseDate.year == date.year) ||
                            prevExpenseData.isEmpty) ...[
                          Text(
                            'On ${date.day}/${date.month}/${date.year}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 4.0,
                          ),
                          child: ListTile(
                            leading: Icon(
                              icon,
                              color: Theme.of(context).primaryColorLight,
                            ),
                            title: Text(
                              expenseData['name'],
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            trailing: Text(
                              'Rs.${addCommasToPrice(expenseData['value'])}',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: expenseList.length,
              ),
      ),
    );
  }
}
