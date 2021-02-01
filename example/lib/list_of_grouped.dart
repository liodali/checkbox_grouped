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
  ListGroupController controller;
  @override
  void initState() {
    super.initState();
    controller = ListGroupController(
      isMultipleSelectionPerGroup: [true, false, true],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListGroupedCheckbox<String>(
            controller: controller,
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
            onSelectedGroupChanged: (list){
              print(list);
            },
          ),
          RaisedButton(
            onPressed: () async {
              final list = await controller.allSelectedItems;
              print(list);
            },
            child: Text("see data"),
          ),
        ],
      ),
    );
  }
}
