import 'package:auto_size_text/auto_size_text.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ///coming soon

  testWidgets("test simple SimpleGroupedCheckbox", (tester) async {
    await tester.pumpWidget(Example1());
    await tester.tap(find.byType(CheckboxListTile).first);
    await tester.pump();
    CheckboxListTile cb=tester.widget(find.byType(CheckboxListTile).first) as CheckboxListTile;
    expect(cb.activeColor, Colors.red);
  });
}

class Example1 extends StatefulWidget {
  Example1({Key key}) : super(key: key);

  @override
  _Example1State createState() => _Example1State();
}

class _Example1State extends State<Example1> {
  GlobalKey<SimpleGroupedCheckboxState<int>> checkboxKey;

  @override
  void initState() {
    super.initState();
    checkboxKey = GlobalKey<SimpleGroupedCheckboxState<int>>();
  }

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
                onItemSeelected: (d){

                },
                values: [1, 2, 4, 5],
                activeColor: Colors.red,
                direction: Direction.Horizontal,
                checkFirstElement: false,
                multiSelection: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
