import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ///coming soon

  testWidgets("test simple SimpleGroupedChip", (tester) async {
    GlobalKey<SimpleGroupedChipsState<int>> chipKey = GlobalKey<SimpleGroupedChipsState<int>>();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SimpleGroupedChips<int>(
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
      ),
    ));
//    await tester.tap(find.byType(ChoiceChip).first);
//    await tester.pump();
    ChoiceChip cb = tester.widget(find.byType(ChoiceChip).at(2)) as ChoiceChip;
    // ChoiceChip cb2=tester.widget(find.byType(ChoiceChip).at(2)) as ChoiceChip;
    await tester.tap(find.byWidget(cb));
    int value = chipKey.currentState.selection();
    expect(value, 4);
  });

  testWidgets("test multiple selection SimpleGroupedChip", (tester) async {
    GlobalKey<SimpleGroupedChipsState<int>> chipKey = GlobalKey<SimpleGroupedChipsState<int>>();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SimpleGroupedChips<int>(
          key: chipKey,
          itemTitle: ["1", "2", "4", "5"],
          values: [1, 2, 4, 5],
          preSelection: [2,4],
          selectedColorItem: Colors.red,
          backgroundColorItem: Colors.white,
          textColor: Colors.black,
          selectedTextColor: Colors.white,
          disabledColor: Colors.grey[200],
          isMultiple: true,
        ),
      ),
    ));
    await tester.pump();

    var values = chipKey.currentState.selection();
    expect(values, [2,4]);
    ChoiceChip cb = tester.widget(find.byType(ChoiceChip).at(2)) as ChoiceChip;
    await tester.tap(find.byWidget(cb));
    values = chipKey.currentState.selection();
    expect(values, [2]);
  });
}
