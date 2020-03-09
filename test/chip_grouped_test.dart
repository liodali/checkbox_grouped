import 'package:auto_size_text/auto_size_text.dart';
import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ///coming soon

  testWidgets("test simple SimpleGroupedChip", (tester) async {
    await tester.pumpWidget(Example1());
//    await tester.tap(find.byType(ChoiceChip).first);
//    await tester.pump();
    ChoiceChip cb=tester.widget(find.byType(ChoiceChip).at(1)) as ChoiceChip;
    ChoiceChip cb2=tester.widget(find.byType(ChoiceChip).at(2)) as ChoiceChip;
    expect(cb.isEnabled, false);
    expect(cb2.isEnabled, true);
  });
}

class Example1 extends StatefulWidget {
  Example1({Key key}) : super(key: key);

  @override
  _Example1State createState() => _Example1State();
}

class _Example1State extends State<Example1> {
  GlobalKey<SimpleGroupedChipsState<int>> chipKey;

  @override
  void initState() {
    super.initState();
    chipKey = GlobalKey<SimpleGroupedChipsState<int>>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("SingleGroupedChip"),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text("Basic"),
              SimpleGroupedChips<int>(
                key: chipKey,
                itemTitle: ["1", "2", "4", "5"],
                values: [1, 2, 4, 5],
                disabledItems: ["2"],
                selectedColorItem: Colors.red,
                backgroundColorItem: Colors.white,
                textColor: Colors.black,
                selectedTextColor: Colors.white,
                disabledColor: Colors.grey[200],
                isMultiple: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
