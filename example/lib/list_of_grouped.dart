import 'dart:math';

import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';

class ListOfGrouped extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListOfGroupedState();
  }
}

class _ListOfGroupedState extends State<ListOfGrouped> {
  GlobalKey<ListGroupedCheckboxState> global ;

  @override
  void initState() {
    super.initState();
    global = GlobalKey<ListGroupedCheckboxState>();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListGroupedCheckbox<String>(
            key: global,
            groupTitles: List.generate(3, (index) => "groupe $index"),
            values: List.generate(
              3,
              (i) =>
                  List.generate(5, (j) => "${(i + Random().nextInt(100)) * j}"),
            ),
            titles: List.generate(
              3,
              (i) => List.generate(5, (j) => "Title:$i-$j"),
            ),
            isMultipleSelectionPerGroup: [true, false, true],
            onSelectedGroupChanged: (list){
              print(list);
            },
          ),
          RaisedButton(
            onPressed: () async {
              final list = await global.currentState.getAllValues();
              print(list);
            },
            child: Text("see data"),
          ),
        ],
      ),
    );
  }
}
