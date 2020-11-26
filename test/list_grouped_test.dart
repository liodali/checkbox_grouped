import 'dart:math';

import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  testWidgets(" test list grouped ", (tester) async {
    GlobalKey<ListGroupedCheckboxState> globalKey =
        GlobalKey<ListGroupedCheckboxState>();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListGroupedCheckbox(
            key: globalKey,
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
          ),
        ),
      ),
    );

    await tester.pump(Duration(seconds: 30));

    await tester.tap(find.byType(CheckboxListTile).at(1));

    await tester.pump(Duration(seconds: 10));
    await tester.tap(find.text("Title:1-0"));
    await tester.pump(Duration(seconds: 10));

    final list = await globalKey.currentState.getAllValues();

    expect(list.length, 2);
  });
}
