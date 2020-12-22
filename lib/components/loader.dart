import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final Color background;
  final Color loader;
  const Loading({
    Key key,
    this.background,
    this.loader,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            backgroundColor: background,
          ),
        ],
      ),
    );
  }
}
