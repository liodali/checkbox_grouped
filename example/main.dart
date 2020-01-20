import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  GlobalKey<SimpleGroupedCheckboxState<int>> checkboxKey =
      GlobalKey<SimpleGroupedCheckboxState<int>>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("SingleGroupedCheckbox"),
        ),
        body: Column(
          children: <Widget>[
            SimpleGroupedCheckbox<int>(
              key: checkboxKey,
              itemsTitle: ["1 ", "2 ", "4 ", "5 "],
              values: [1, 2, 4, 5],
              activeColor: Colors.red,
              direction: Direction.Horizontal,
              checkFirstElement: false,
              multiSelection: false,
            )
          ],
        ),
      ),
    );
  }
}
