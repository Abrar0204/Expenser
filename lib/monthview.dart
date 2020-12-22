import 'package:Expenser/expenseTracker.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:pie_chart/pie_chart.dart';

import 'components/loader.dart';

class MonthView extends StatefulWidget {
  @override
  _MonthViewState createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  String name = '';
  double income = 0.0;
  bool isLoading = true;
  List expenseData = [];
  List expenseDataType0 = [];
  List expenseDataType1 = [];
  List expenseDataType2 = [];
  List expenseDataType3 = [];
  List expenseDataType4 = [];
  List expenseDataType5 = [];
  List expenseDataType6 = [];
  List expenseDataType7 = [];
  List expenseDataType8 = [];
  List expenseDataType9 = [];
  List expenseDataByTypes = [];
  List<Color> colorList = [
    Color(0xFFFCFCFC),
    Color(0xFFB8D4E3),
    Color(0xFFD1FFD7),
    Color(0xFFFFE66D),
    Color(0xFF6CA6C1),
    Color(0xFFFF495C),
    Color(0xFFE1CA96),
    Color(0xFFDE9151),
    Color(0xFFFFCB47),
    Color(0xFFD3D0CB),
  ];
  double totalExpense = 0.0;
  var selectedDate = DateTime.now();
  var selectedDateString = '';

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

  void getData() async {
    setState(() {
      isLoading = true;
    });

    selectedDateString =
        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';

    var currentMonthAndYear =
        '${months[selectedDate.month - 1]}${selectedDate.year}';
    print(currentMonthAndYear);
    var userBox = await Hive.openBox('userData');
    var expenseBox = await Hive.openBox('expenseData');
    var tempName = userBox.get('name') ?? 'Anonymous';
    var tempIncome = userBox.get('salary') ?? 0.0;
    var expenseDataRaw = expenseBox.get(currentMonthAndYear) ??
        []; //all data in the month by dates
    expenseData = [];
    expenseDataRaw.forEach((element) {
      expenseData.addAll(element['expenses']); //all expense data in the month
    });

    expenseData.forEach((element) {
      totalExpense += element['value'];
      if (element['type'] == 0)
        expenseDataType0.add(element);
      else if (element['type'] == 1)
        expenseDataType1.add(element);
      else if (element['type'] == 2)
        expenseDataType2.add(element);
      else if (element['type'] == 3)
        expenseDataType3.add(element);
      else if (element['type'] == 4)
        expenseDataType4.add(element);
      else if (element['type'] == 5)
        expenseDataType5.add(element);
      else if (element['type'] == 6)
        expenseDataType6.add(element);
      else if (element['type'] == 7)
        expenseDataType7.add(element);
      else if (element['type'] == 8)
        expenseDataType8.add(element);
      else if (element['type'] == 9) expenseDataType9.add(element);
    });

    var tempTotalExpenseOfType = 0.0;
    expenseDataType0.forEach((element) {
      tempTotalExpenseOfType += element['value'];
    });
    expenseDataByTypes.add({
      'type': 0,
      'name': 'Groceries',
      'value': tempTotalExpenseOfType,
      'expenses': expenseDataType0,
    });

    tempTotalExpenseOfType = 0.0;
    expenseDataType1.forEach((element) {
      tempTotalExpenseOfType += element['value'];
    });
    expenseDataByTypes.add({
      'type': 1,
      'name': 'Rent',
      'value': tempTotalExpenseOfType,
      'expenses': expenseDataType1,
    });

    tempTotalExpenseOfType = 0.0;
    expenseDataType2.forEach((element) {
      tempTotalExpenseOfType += element['value'];
    });
    expenseDataByTypes.add({
      'type': 2,
      'name': 'Games/Entertain..',
      'value': tempTotalExpenseOfType,
      'expenses': expenseDataType2,
    });

    tempTotalExpenseOfType = 0.0;
    expenseDataType3.forEach((element) {
      tempTotalExpenseOfType += element['value'];
    });
    expenseDataByTypes.add({
      'type': 3,
      'name': 'Food/Restaurant',
      'value': tempTotalExpenseOfType,
      'expenses': expenseDataType3,
    });

    tempTotalExpenseOfType = 0.0;
    expenseDataType4.forEach((element) {
      tempTotalExpenseOfType += element['value'];
    });
    expenseDataByTypes.add({
      'type': 4,
      'name': 'Electricity',
      'value': tempTotalExpenseOfType,
      'expenses': expenseDataType4,
    });

    tempTotalExpenseOfType = 0.0;
    expenseDataType5.forEach((element) {
      tempTotalExpenseOfType += element['value'];
    });
    expenseDataByTypes.add({
      'type': 5,
      'name': 'Health/Medical',
      'value': tempTotalExpenseOfType,
      'expenses': expenseDataType5,
    });

    tempTotalExpenseOfType = 0.0;
    expenseDataType6.forEach((element) {
      tempTotalExpenseOfType += element['value'];
    });
    expenseDataByTypes.add({
      'type': 6,
      'name': 'Travel',
      'value': tempTotalExpenseOfType,
      'expenses': expenseDataType6,
    });

    tempTotalExpenseOfType = 0.0;
    expenseDataType7.forEach((element) {
      tempTotalExpenseOfType += element['value'];
    });
    expenseDataByTypes.add({
      'type': 7,
      'name': 'Electronics',
      'value': tempTotalExpenseOfType,
      'expenses': expenseDataType7,
    });

    tempTotalExpenseOfType = 0.0;
    expenseDataType8.forEach((element) {
      tempTotalExpenseOfType += element['value'];
    });
    expenseDataByTypes.add({
      'type': 8,
      'name': 'Services',
      'value': tempTotalExpenseOfType,
      'expenses': expenseDataType8,
    });

    tempTotalExpenseOfType = 0.0;
    expenseDataType9.forEach((element) {
      tempTotalExpenseOfType += element['value'];
    });
    expenseDataByTypes.add({
      'type': 9,
      'name': 'Others',
      'value': tempTotalExpenseOfType,
      'expenses': expenseDataType9,
    });

    print(expenseDataByTypes);

    setState(() {
      name = tempName;
      isLoading = false;
      income = tempIncome;
    });
  }

  Widget pieChart() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: PieChart(
        dataMap: {
          'Grocercies': expenseDataByTypes[0]['value'],
          'Rent': expenseDataByTypes[1]['value'],
          'Games/Entertainment': expenseDataByTypes[2]['value'],
          'Food/Restaurant': expenseDataByTypes[3]['value'],
          'Electricity': expenseDataByTypes[4]['value'],
          'Health/Medical': expenseDataByTypes[5]['value'],
          'Travels': expenseDataByTypes[6]['value'],
          'Electronics': expenseDataByTypes[7]['value'],
          'Services': expenseDataByTypes[8]['value'],
          'Others': expenseDataByTypes[9]['value'],
        },
        animationDuration: Duration(milliseconds: 600),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 2.3,
        initialAngleInDegree: -90,
        colorList: colorList,
        chartType: ChartType.ring,
        ringStrokeWidth: 23,
        legendOptions: LegendOptions(
          showLegends: false,
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: false,
          showChartValuesInPercentage: true,
          showChartValuesOutside: false,
        ),
      ),
    );
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

  Widget expenseList() {
    return Expanded(
        child: ListView.builder(
      itemBuilder: (context, index) {
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
        Color tileColor = colorList[index];

        double percentage = (expenseDataByTypes[index]['value'] / income) * 100;

        return expenseDataByTypes[index]['value'] != 0.0
            ? ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ExpenseTracker(
                        expenseData: expenseDataByTypes[index],
                      ),
                    ),
                  );
                },
                leading: Icon(iconList[index], color: tileColor),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      expenseDataByTypes[index]['name'],
                      style: TextStyle(
                        fontSize: 16,
                        color: tileColor,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    Text(
                      'Rs.' +
                          addCommasToPrice(expenseDataByTypes[index]['value']),
                      style: TextStyle(
                        fontSize: 15,
                        color: tileColor,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: tileColor,
                ),
                subtitle: Text(
                  '${percentage.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: tileColor,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            : SizedBox.shrink();
      },
      itemCount: expenseDataByTypes.length,
    ));
  }

  void selectDate(BuildContext context) async {
    final DateTime picked = await showMonthPicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      print(picked);
      setState(() {
        selectedDate = picked;
        selectedDateString =
            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
        getData();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                'Report For ${months[selectedDate.month - 1]} ${selectedDate.year}',
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).primaryColorLight,
                  ),
                  onPressed: () {
                    selectDate(context);
                  },
                ),
              ],
            ),
            backgroundColor: Theme.of(context).primaryColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 12.0,
              ),
              child: Column(
                mainAxisAlignment: expenseData.isNotEmpty
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (expenseData.isEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.account_balance_wallet,
                            size: 80,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          Text(
                            'No Transactions have been made in this month.',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    pieChart(),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Expenses',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            Text(
                              '\u20B9' + addCommasToPrice(totalExpense),
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Balance',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            Text(
                              '\u20B9' +
                                  addCommasToPrice(income - totalExpense),
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    expenseList(),
                  ],
                ],
              ),
            ),
          );
  }
}
