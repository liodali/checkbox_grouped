import 'package:flutter/material.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';

class CustomGroupedExample extends StatefulWidget {
  CustomGroupedExample({Key key}) : super(key: key);

  @override
  _CustomGroupedExampleState createState() => _CustomGroupedExampleState();
}

class _CustomGroupedExampleState extends State<CustomGroupedExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Other Example"),
      ),
      body: CustomGroupedCheckbox<int>(
        groupTitle: "Custom GroupedCheckbox",
        itemBuilder: (ctx,index){
          return Card(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("$index"),
            ),
          );
        },
        itemCount: 10,
        values: List<int>.generate(10, (i)=>i),
      ),
    );
  }
}