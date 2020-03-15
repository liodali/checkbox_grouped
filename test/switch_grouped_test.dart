import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ///coming soon

  testWidgets("test single selection SimpleGroupedSwitch ", (tester) async {
    await tester.pumpWidget(Example1());
    await tester.tap(find.byType(SwitchListTile).at(1));
//    await tester.pump();

    SwitchListTile cb =
        tester.widget(find.byType(SwitchListTile).first) as SwitchListTile;
    SwitchListTile cb2 =
        tester.widget(find.byType(SwitchListTile).at(1)) as SwitchListTile;
    expect(cb.value, false);
    expect(cb2.value, true);
  });
}

class Example1 extends StatefulWidget {
  final bool isMultiple;

  Example1({Key key, this.isMultiple = false}) : super(key: key);

  @override
  _Example1State createState() => _Example1State();
}

class _Example1State extends State<Example1> {
  GlobalKey<SimpleGroupedSwitchState<int>> switchKey;

  @override
  void initState() {
    super.initState();
    switchKey = GlobalKey<SimpleGroupedSwitchState<int>>();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("SingleGroupedSwitch"),
        ),
        body: SimpleGroupedSwitch<int>(
          key: switchKey,
          itemsTitle: ["1", "2", "4", "5"],
          values: [1, 2, 4, 5],
          isMutlipleSelection: widget.isMultiple,
        ),
      ),
    );
  }
}
