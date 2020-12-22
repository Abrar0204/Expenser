import 'package:Expenser/components/loader.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pie_chart/pie_chart.dart';

class MonthlyView extends StatefulWidget {
  final String name;
  final double salary;

  MonthlyView({
    Key key,
    this.name,
    this.salary,
  }) : super(key: key);

  @override
  _MonthlyViewState createState() => _MonthlyViewState();
}

class _MonthlyViewState extends State<MonthlyView> {
  double salary = 60000; //dummy value
  String name = 'Anonymous'; //dummy value
  bool isLoading = true;
  double expense = 0.0;
  String type = '';

  var _formKey = GlobalKey<FormState>();
  List types = [];
  List<String> colors = [
    '#A393BF',
    '#9D44B5',
    '#EC7357',
    '#A5402D',
    '#DDDBF1',
    '#FFC857',
    '#4B3F72',
    '#8F5C38',
    '#FF4B3E',
    '#247B7B',
    '#E5ECF4',
  ];

  Map<String, double> dataMap = {};

  List<Color> colorListForChart = [];

  void getExpenseData() async {
    var box = await Hive.openBox('userData');
    var dataBox = await Hive.openBox('expenseData');
    print(dataBox.values);
    Map savingsData = {
      'name': 'Savings',
      'icon': 'monetization_on',
      'value': box.get('salary').toString(),
      'color': colors[0],
    };

    List tempExpenses = box.get('expenses') ?? [];
    if (tempExpenses.isEmpty) {
      box.put(
        'expenses',
        [savingsData],
      );
      tempExpenses.add(savingsData);
    }

    setState(() {
      name = box.get('name');
      salary = box.get('salary');
      types = tempExpenses;
      isLoading = false;
    });
  }

  Widget welcomeWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello,',
          style: TextStyle(
            color: Colors.amberAccent,
            fontSize: 20,
            fontWeight: FontWeight.w200,
          ),
        ),
        Text(
          name ?? 'Anonymous',
          style: TextStyle(
            color: Colors.amberAccent,
            fontSize: 30,
          ),
        )
      ],
    );
  }

  Widget expenseList() {
    return Expanded(
      child: ListView.builder(
        itemCount: types.length,
        itemBuilder: (context, index) {
          var percentage = (double.parse(types[index]['value']) / salary) * 100;

          var color =
              Color(int.parse("0xFF${types[index]['color'].substring(1)}"));
          var icon;
          if (types[index]['icon'] == 'monetization_on') {
            icon = Icons.monetization_on;
          }

          return ListTile(
            subtitle: Text(
              "${percentage.toStringAsFixed(2)} %",
              style: TextStyle(
                color: color,
              ),
            ),
            leading: Icon(
              icon,
              color: color,
            ),
            title: Text(
              types[index]['name'],
              style: TextStyle(
                color: color,
              ),
            ),
            trailing: Text(
              "Rs. ${types[index]['value']}",
              style: TextStyle(
                color: color,
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration formInputDecoration(labelText) {
    return InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.amberAccent,
          style: BorderStyle.solid,
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey[900],
          style: BorderStyle.solid,
        ),
      ),
      labelText: labelText,
      labelStyle: TextStyle(
        color: Colors.grey,
      ),
    );
  }

  void _showDialog() {
    // flutter defined function

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        final node = FocusScope.of(context);
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: Text(
            "Add a Expenditure",
            style: TextStyle(
              color: Colors.amberAccent,
            ),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  onEditingComplete: () => node.nextFocus(),
                  onChanged: (val) {
                    type = val;
                  },
                  // ignore: missing_return
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a Type of Expenditure';
                    }
                  },
                  cursorColor: Colors.amber[50],
                  style: TextStyle(
                    color: Colors.amber,
                  ),
                  decoration: formInputDecoration('Expenditure Type'),
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
                      return 'Please enter a Amount';
                    } else if (!(double.parse(value) is double)) {
                      return 'Please Enter a Number';
                    }
                  },
                  cursorColor: Colors.amber[50],
                  style: TextStyle(
                    color: Colors.amber,
                  ),
                  decoration: formInputDecoration('Amount in Rupees'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              color: Colors.amber,
              child: new Text(
                "Add",
                style: TextStyle(color: Colors.grey[850]),
              ),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  var box = await Hive.openBox('userData');
                  List prevExpenseData = box.get('expenses');
                  double totalExpense = 0.0;
                  double newSavings = 0.0;
                  prevExpenseData.forEach((element) {
                    if (element['name'] != 'Savings') {
                      totalExpense += double.parse(element['value']);
                    }
                  });
                  newSavings = salary - totalExpense - expense;
                  prevExpenseData[0]['value'] = newSavings.toString();
                  print(newSavings);
                  print(totalExpense);
                  var expenseData = {
                    'name': type,
                    'icon': 'monetization_on',
                    'value': expense.toString(),
                    'color': colors[prevExpenseData.length],
                  };
                  prevExpenseData.add(expenseData);
                  box.put('expenses', prevExpenseData);
                  setState(() {
                    types = prevExpenseData;
                  });
                  // _chartKey.currentState.createDataMap();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget pieChart() {
    types.forEach((value) {
      dataMap['${value['name']}'] = double.parse(value['value']);
    });
    // print(dataMap);
    colorListForChart = [];
    var count = 0;
    colors.forEach((element) {
      if (count != types.length) {
        count++;
        var colorCode = "0xFF${element.substring(1)}";
        colorListForChart.add(Color(int.parse(colorCode)));
      }
    });
    // print(colorListForChart);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 2,
        initialAngleInDegree: 0,
        colorList: colorListForChart,
        chartType: ChartType.ring,
        ringStrokeWidth: 22,
        legendOptions: LegendOptions(
          showLegends: false,
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: false,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
        ),
      ),
    );
  }

  Widget floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        _showDialog();
      },
      child: Icon(
        Icons.add,
        color: Colors.grey[850],
      ),
      backgroundColor: Colors.amberAccent,
    );
  }

  @override
  void initState() {
    super.initState();
    getExpenseData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading(
            background: Colors.grey[900],
            loader: Colors.amberAccent,
          )
        : Scaffold(
            backgroundColor: Colors.grey[900],
            floatingActionButton: floatingActionButton(),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  welcomeWidget(),
                  pieChart(),
                  expenseList(),
                ],
              ),
            ),
          );
  }
}
