import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Type typeOf<T>() => T;

void main() {
  testWidgets("test single selection", (tester) async {
    GlobalKey<SimpleGroupedCheckboxState<int>> checkboxKey =
        GlobalKey<SimpleGroupedCheckboxState<int>>();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SimpleGroupedCheckbox<int>(
          key: checkboxKey,
          itemsTitle: List.generate(10, (index) => "${index + 1}"),
          values: List.generate(10, (index) => index + 1),
          activeColor: Colors.red,
          checkFirstElement: true,
          multiSelection: false,
          isLeading: true,
        ),
      ),
    ));
    //await tester.pump(Duration(seconds: 5));
    await tester.pump();

    //await tester.tap(find.byType(RadioListTile).first);
    //var rb0 = tester.widget(find.byElementType(RadioListTile).first) as RadioListTile<int>;
    expect(checkboxKey.currentState.selection(), 1);
    await tester.pump();
    var finder = find.text("3");
    await tester.tap(finder);
    expect(checkboxKey.currentState.selection(), 3);
  });
  testWidgets("test multiple selection simple SimpleGroupedCheckbox",
      (tester) async {
    GlobalKey<SimpleGroupedCheckboxState<int>> globalKey =
        GlobalKey<SimpleGroupedCheckboxState<int>>();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SimpleGroupedCheckbox<int>(
          key: globalKey,
          itemsTitle: List.generate(10, (index) => "$index"),
          values: List.generate(10, (index) => index),
          preSelection: [],
          activeColor: Colors.green,
          checkFirstElement: false,
          multiSelection: true,
          onItemSelected: (data) {
            print(data);
          },
          isExpandableTitle: false,
        ),
      ),
    ));
    await tester.pump();
    //tester.allElements;
    await tester.tap(find.byType(CheckboxListTile).first);
    await tester.pump();
    CheckboxListTile cb =
        tester.widget(find.byType(CheckboxListTile).first) as CheckboxListTile;
    expect(cb.value, true);
    await tester.tap(find.byType(CheckboxListTile).at(1));
    await tester.pump(Duration(seconds: 5));

    var cb2 =
        tester.widget(find.byType(CheckboxListTile).at(1)) as CheckboxListTile;
    expect(cb2.value, true);
    expect((globalKey.currentState.selection() as List), [0, 1]);
  });

  testWidgets("test pre-selection for single selection", (tester) async {
    GlobalKey<SimpleGroupedCheckboxState<int>> checkboxKey =
        GlobalKey<SimpleGroupedCheckboxState<int>>();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SimpleGroupedCheckbox<int>(
          key: checkboxKey,
          itemsTitle: List.generate(10, (index) => "${index + 1}"),
          values: List.generate(10, (index) => index + 1),
          preSelection: [2],
          activeColor: Colors.red,
          checkFirstElement: false,
          multiSelection: false,
          isLeading: true,
        ),
      ),
    ));
    await tester.pump();

    expect(checkboxKey.currentState.selection(), 2);
    await tester.pump();
    var finder = find.text("3");
    await tester.tap(finder);
    expect(checkboxKey.currentState.selection(), 3);
  });
  testWidgets("test disable function", (tester) async {
    GlobalKey<SimpleGroupedCheckboxState<int>> checkboxKey =
        GlobalKey<SimpleGroupedCheckboxState<int>>();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SimpleGroupedCheckbox<int>(
          key: checkboxKey,
          itemsTitle: List.generate(10, (index) => "${index + 1}"),
          values: List.generate(10, (index) => index + 1),
          preSelection: [2],
          activeColor: Colors.red,
          checkFirstElement: false,
          multiSelection: false,
          isLeading: true,
        ),
      ),
    ));
    await tester.pump();
    checkboxKey.currentState.disabledItemsByValues([3, 4]);
    await tester.pump();
    var widget = tester.widget(find.byType(typeOf<RadioListTile<int>>()).at(2))
        as RadioListTile;
    expect(widget.value, 3);
    expect(widget.onChanged, null);
    checkboxKey.currentState.enabledItemsByValues([3]);
    await tester.pump();
    await tester.tap(find.byType(typeOf<RadioListTile<int>>()).at(2));
    expect(checkboxKey.currentState.selection(), 3);
  });
  testWidgets("test helperGroupTitle : false  simple SimpleGroupedCheckbox",
      (tester) async {
    GlobalKey<SimpleGroupedCheckboxState<int>> globalKey =
        GlobalKey<SimpleGroupedCheckboxState<int>>();
    var listValues = List.generate(5, (index) => index);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SimpleGroupedCheckbox<int>(
            key: globalKey,
            itemsTitle: List.generate(5, (index) => "$index"),
            values: listValues,
            preSelection: [],
            groupTitle: "group test",
            activeColor: Colors.green,
            checkFirstElement: false,
            multiSelection: true,
            helperGroupTitle: false,
            isExpandableTitle: false,
          ),
        ),
      ),
    );
    await tester.pump();
    final listTiles = tester.elementList(find.byType(ListTile));

    expect(listTiles.length, listValues.length);
    await tester.tap(find.byType(ListTile).first);
    await tester.pump();
    expect(globalKey.currentState.selection(), [listValues.first]);
  });
  testWidgets("test helperGroupTitle : true simple SimpleGroupedCheckbox",
      (tester) async {
    GlobalKey<SimpleGroupedCheckboxState<int>> globalKey =
        GlobalKey<SimpleGroupedCheckboxState<int>>();
    var listValues = List.generate(5, (index) => index);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SimpleGroupedCheckbox<int>(
            key: globalKey,
            itemsTitle: List.generate(5, (index) => "$index"),
            values: listValues,
            preSelection: [],
            groupTitle: "group test",
            activeColor: Colors.green,
            checkFirstElement: false,
            multiSelection: true,
            helperGroupTitle: true,
            isExpandableTitle: false,
          ),
        ),
      ),
    );
    await tester.pump();
    //tester.allElements;
    final listTiles = tester.elementList(find.byType(ListTile));

    expect(listTiles.length, listValues.length + 1);
    await tester.tap(find.byType(ListTile).first);
    await tester.pump();
    expect(globalKey.currentState.selection(), listValues);
  });
}
