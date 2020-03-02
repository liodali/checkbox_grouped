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
  GlobalKey<SimpleGroupedCheckboxState<int>> circulairekey =
      GlobalKey<SimpleGroupedCheckboxState<int>>();
  GlobalKey<SimpleGroupedCheckboxState<int>> mutlicheckboxKey =
      GlobalKey<SimpleGroupedCheckboxState<int>>();

  GlobalKey<SimpleGroupedChipsState<int>> mutliChipsKey =
  GlobalKey<SimpleGroupedChipsState<int>>();

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
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text("Basic"),
              SimpleGroupedCheckbox<int>(
                key: checkboxKey,
                itemsTitle: ["1 ", "2 ", "4 ", "5 "],
                values: [1, 2, 4, 5],
                activeColor: Colors.red,
                direction: Direction.Horizontal,
                checkFirstElement: false,
                multiSelection: false,
              ),
              Text("Circulaire Checkbox"),
              SimpleGroupedCheckbox<int>(
                key: circulairekey,
                itemsTitle: ["1 ", "2 ", "4 ", "5 "],
                values: [1, 2, 4, 5],
                direction: Direction.Horizontal,
                isCirculaire: true,
                activeColor: Colors.blue,
                isLeading: true,
                checkFirstElement: false,
                multiSelection: false,
              ),
              SimpleGroupedCheckbox<int>(
                key: mutlicheckboxKey,
                itemsTitle: ["1 ", "2 ", "4 ", "5 "],
                values: [1, 2, 4, 5],
                preSelection: [2, 5, 4],
                textTitle: "Mutiple selection",
                activeColor: Colors.green,
                direction: Direction.Horizontal,
                checkFirstElement: false,
                multiSelection: true,
                isExpandableTitle: true,
              ),
              SimpleGroupedChips<int>(
                key: mutliChipsKey,
                values: [1,2,3,4,5,6,7],
                itemTitle: ["text1","text2","text3","text4","text5","text6","text7"],
                backgroundColorItem: Colors.black26,
                isScrolling: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
