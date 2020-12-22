import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({
    Key key,
    @required this.login,
  }) : super(key: key);

  final Function login;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String name = '';

  double salary = 0.0;

  var _formKey = GlobalKey<FormState>();

  Widget welcomeWidget() {
    return Column(
      children: [
        Text(
          'Welcome To,',
          style: TextStyle(
            color: Theme.of(context).primaryColorLight,
            fontWeight: FontWeight.w200,
            fontSize: 30,
          ),
        ),
        Text(
          'EXPENSER',
          style: TextStyle(
            color: Theme.of(context).primaryColorLight,
            fontWeight: FontWeight.w700,
            fontSize: 45,
          ),
        ),
      ],
    );
  }

  InputDecoration inputDecoration(labelText) {
    return InputDecoration(
      focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
      enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
      labelText: labelText,
      labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
    );
  }

  Widget formWidget(node) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              onEditingComplete: () => node.nextFocus(),
              onChanged: (val) {
                name = val;
              },
              // ignore: missing_return
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please Enter Your Name.';
                }
              },
              cursorColor: Theme.of(context).primaryColorLight,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: inputDecoration('Your Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              onFieldSubmitted: (_) => node.unfocus(),
              onChanged: (val) {
                salary = double.parse(val);
              },
              // ignore: missing_return
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please Enter Your Monthly Salary';
                } else if (!(double.parse(value) is double)) {
                  return 'Please Enter A Number';
                }
              },
              cursorColor: Theme.of(context).primaryColorLight,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: inputDecoration('Your Salary (per Month)'),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FlatButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                widget.login(name, salary);
              }
            },
            color: Theme.of(context).buttonColor,
            child: new Text(
              "Get Started",
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          welcomeWidget(),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  15,
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: formWidget(node),
          ),
        ],
      ),
    );
  }
}
