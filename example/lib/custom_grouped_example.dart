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
    return CustomGroupedCheckbox<int>(
      groupTitle: Container(
        padding: EdgeInsets.all(5.0),
        child: Text("Custom GroupedCheckbox"),
      ),
      itemBuilder: (ctx, index, v) {
        return Card(
          margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("$index"),
                  ),
                ),
              ),
              Opacity(
                opacity: v?1:0,
                child: Icon(Icons.check,color: Colors.green,size: 24,),
              ),
            ],
          ),
        );
      },
      itemCount: 10,
      values: List<int>.generate(10, (i) => i),
    );
  }
}
