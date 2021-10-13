import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:checkbox_grouped/src/controller/group_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Type typeOf<T>() => T;

void main() {
  testWidgets("test multiple selection simple SimpleGroupedCheckbox",
      (tester) async {
    GroupController controller = GroupController(
      isMultipleSelection: true,
    );
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SimpleGroupedCheckbox<int>(
          controller: controller,
          itemsTitle: List.generate(10, (index) => "$index"),
          values: List.generate(10, (index) => index),
          groupStyle: GroupStyle(
            activeColor: Colors.green,
          ),
          checkFirstElement: false,
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
    expect((controller.selectedItem as List<int>?), [0, 1]);
  });

  testWidgets("test pre-selection for single selection", (tester) async {
    GroupController controller =
        GroupController(isMultipleSelection: false, initSelectedItem: [2]);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SimpleGroupedCheckbox<int>(
          controller: controller,
          itemsTitle: List.generate(10, (index) => "${index + 1}"),
          values: List.generate(10, (index) => index + 1),
          groupStyle: GroupStyle(
            activeColor: Colors.green,
          ),
          checkFirstElement: false,
          isLeading: true,
        ),
      ),
    ));
    await tester.pump();

    expect(controller.selectedItem, 2);
    await tester.pump();
    var finder = find.text("3");
    await tester.tap(finder);
    expect(controller.selectedItem, 3);
  });

  testWidgets("test disable function", (tester) async {
    GroupController controller =
        GroupController(isMultipleSelection: false, initSelectedItem: [2]);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SimpleGroupedCheckbox<int>(
          controller: controller,
          itemsTitle: List.generate(10, (index) => "${index + 1}"),
          values: List.generate(10, (index) => index + 1),
          groupStyle: GroupStyle(
            activeColor: Colors.green,
          ),
          checkFirstElement: false,
          isLeading: true,
        ),
      ),
    ));
    await tester.pump();
    controller.disabledItemsByValues([3, 4]);
    await tester.pump();
    // var widget = tester.widget(find.byType(typeOf<RadioListTile<int>>()).at(2))
    //     as RadioListTile;
    // expect(widget.value, 3);
    // expect(widget.onChanged, null);
    controller.enabledItemsByValues([3]);
    await tester.pump();
    await tester.tap(find.text("3"));
    expect(controller.selectedItem, 3);
  });

  testWidgets("test helperGroupTitle : false  simple SimpleGroupedCheckbox",
      (tester) async {
    GroupController controller =
        GroupController(isMultipleSelection: true, initSelectedItem: []);
    var listValues = List.generate(5, (index) => index);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SimpleGroupedCheckbox<int>(
            controller: controller,
            itemsTitle: List.generate(5, (index) => "name $index"),
            values: listValues,
            groupTitle: "group test",
            groupStyle: GroupStyle(
              activeColor: Colors.green,
            ),
            checkFirstElement: false,
            helperGroupTitle: false,
            isExpandableTitle: false,
          ),
        ),
      ),
    );
    await tester.pump();
    final listTiles = tester.elementList(find.byType(CheckboxListTile));

    expect(listTiles.length, listValues.length);
    await tester.tap(find.byType(CheckboxListTile).first);
    await tester.pump();
    expect(controller.selectedItem, [listValues.first]);
  });
  testWidgets("test helperGroupTitle : true simple SimpleGroupedCheckbox",
      (tester) async {
    GroupController controller = GroupController(
      isMultipleSelection: true,
      initSelectedItem: [],
    );
    var listValues = List.generate(5, (index) => index);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SimpleGroupedCheckbox<int>(
            controller: controller,
            itemsTitle: List.generate(5, (index) => "$index"),
            values: listValues,
            groupTitle: "group test",
            groupStyle: GroupStyle(
              activeColor: Colors.green,
            ),
            checkFirstElement: false,
            helperGroupTitle: true,
            isExpandableTitle: false,
          ),
        ),
      ),
    );
    await tester.pump();
    //tester.allElements;
    final listTiles = tester.elementList(find.byType(CheckboxListTile));

    expect(listTiles.length, listValues.length);
    await tester.tap(find.byType(ListTile).first);
    await tester.pump();
    expect(controller.selectedItem, listValues);
  });

  testWidgets("test GroupController single selection", (tester) async {
    GroupController controller = GroupController();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SimpleGroupedCheckbox<int>(
          controller: controller,
          itemsTitle: List.generate(10, (index) => "${index + 1}"),
          values: List.generate(10, (index) => index + 1),
          groupStyle: GroupStyle(
            activeColor: Colors.green,
          ),
          checkFirstElement: true,
          isLeading: true,
        ),
      ),
    ));
    //await tester.pump(Duration(seconds: 5));
    await tester.pump();
    //await tester.tap(find.byType(RadioListTile).first);
    //var rb0 = tester.widget(find.byElementType(RadioListTile).first) as RadioListTile<int>;
    expect(controller.selectedItem, 1);
    await tester.pump();
    var finder = find.text("3");
    await tester.tap(finder);
    expect(controller.selectedItem, 3);
  });
  testWidgets("test enableAll and disableAll GroupController single selection",
      (tester) async {
    GroupController controller = GroupController();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SimpleGroupedCheckbox<int>(
          controller: controller,
          itemsTitle: List.generate(10, (index) => "${index + 1}"),
          values: List.generate(10, (index) => index + 1),
          groupStyle: GroupStyle(
            activeColor: Colors.green,
          ),
          checkFirstElement: false,
          isLeading: true,
        ),
      ),
    ));
    //await tester.pump(Duration(seconds: 5));
    await tester.pump();
    controller.disableAll();
    await tester.pump();

    var finder = find.text("3");
    await tester.tap(finder);

    await tester.pump();

    expect(controller.selectedItem, null);
    await tester.pump();
    controller.enableAll();
    await tester.pump();

    await tester.tap(finder);

    await tester.pump();
    expect(controller.selectedItem, 3);
  });

  testWidgets("test One Select GroupController single selection",
      (tester) async {
    GroupController controller = GroupController();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SimpleGroupedCheckbox<int>(
          controller: controller,
          itemsTitle: List.generate(10, (index) => "${index + 1}"),
          values: List.generate(10, (index) => index + 1),
          groupStyle: GroupStyle(
            activeColor: Colors.green,
          ),
          checkFirstElement: true,
          isLeading: true,
        ),
      ),
    ));
    //await tester.pump(Duration(seconds: 5));
    await tester.pump();
    //await tester.tap(find.byType(RadioListTile).first);
    //var rb0 = tester.widget(find.byElementType(RadioListTile).first) as RadioListTile<int>;
    expect(controller.selectedItem, 1);
    await tester.pump();
    controller.select(3);
    await tester.pump();
    expect(controller.selectedItem, 3);
    controller.select(4);
    await tester.pump();
    expect(controller.selectedItem, 4);

    /// test no accepting list
    expect(() => controller.select([4, 3]), throwsA(isA<AssertionError>()));
  });

  testWidgets("test One Select GroupController multiple selection",
      (tester) async {
    GroupController controller = GroupController(isMultipleSelection: true);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SimpleGroupedCheckbox<int>(
          controller: controller,
          itemsTitle: List.generate(10, (index) => "${index + 1}"),
          values: List.generate(10, (index) => index + 1),
          groupStyle: GroupStyle(
            activeColor: Colors.green,
          ),
          checkFirstElement: true,
          isLeading: true,
        ),
      ),
    ));
    //await tester.pump(Duration(seconds: 5));
    await tester.pump();
    //await tester.tap(find.byType(RadioListTile).first);
    //var rb0 = tester.widget(find.byElementType(RadioListTile).first) as RadioListTile<int>;
    expect(controller.selectedItem, [1]);
    await tester.pump();
    controller.select(3);
    await tester.pump();
    expect(controller.selectedItem, [1, 3]);
    controller.select(4);
    await tester.pump();
    expect(controller.selectedItem, [1, 3, 4]);
  });

  testWidgets("test select all in multiple selection  SimpleGroupedCheckbox",
      (tester) async {
    GroupController controller =
        GroupController(isMultipleSelection: true, initSelectedItem: [1, 2]);
    final values = List.generate(10, (index) => index);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SimpleGroupedCheckbox<int>(
          controller: controller,
          itemsTitle: List.generate(10, (index) => "$index"),
          values: values,
          groupStyle: GroupStyle(
            activeColor: Colors.green,
          ),
          checkFirstElement: false,
          onItemSelected: (data) {
            print(data);
          },
          isExpandableTitle: false,
        ),
      ),
    ));
    await tester.pump();
    //tester.allElements;
    expect(controller.selectedItem, [1, 2]);
    controller.selectAll();
    await tester.pump();
    final controllerValues = List.from(controller.selectedItem);
    controllerValues.sort();
    expect(controllerValues, values);
  });

  testWidgets(
      "test select some values in multiple selection  SimpleGroupedCheckbox",
      (tester) async {
    GroupController controller =
        GroupController(isMultipleSelection: true, initSelectedItem: [1, 2]);
    final values = List.generate(10, (index) => index);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SimpleGroupedCheckbox<int>(
          controller: controller,
          itemsTitle: List.generate(10, (index) => "$index"),
          values: values,
          groupStyle: GroupStyle(
            activeColor: Colors.green,
          ),
          checkFirstElement: false,
          onItemSelected: (data) {
            print(data);
          },
          isExpandableTitle: false,
        ),
      ),
    ));
    await tester.pump();
    //tester.allElements;
    expect(controller.selectedItem, [1, 2]);
    controller.selectItems([3, 5]);
    await tester.pump();
    final controllerValues = List.from(controller.selectedItem);
    controllerValues.sort();
    expect(controllerValues, [1, 2, 3, 5]);
  });
  testWidgets(
      "test deselect some values in multiple selection  SimpleGroupedCheckbox",
      (tester) async {
    GroupController controller =
        GroupController(isMultipleSelection: true, initSelectedItem: [1, 2]);
    final values = List.generate(10, (index) => index);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SimpleGroupedCheckbox<int>(
          controller: controller,
          itemsTitle: List.generate(10, (index) => "$index"),
          values: values,
          groupStyle: GroupStyle(
            activeColor: Colors.green,
          ),
          checkFirstElement: false,
          onItemSelected: (data) {
            print(data);
          },
          isExpandableTitle: false,
        ),
      ),
    ));
    await tester.pump();
    //tester.allElements;
    expect(controller.selectedItem, [1, 2]);
    controller.deselectValues([2]);
    await tester.pump();
    expect(controller.selectedItem, [1]);
  });

  testWidgets("test deselect all in multiple selection  SimpleGroupedCheckbox",
      (tester) async {
    GroupController controller =
        GroupController(isMultipleSelection: true, initSelectedItem: [1, 2]);
    final values = List.generate(10, (index) => index);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SimpleGroupedCheckbox<int>(
          controller: controller,
          itemsTitle: List.generate(10, (index) => "$index"),
          values: values,
          groupStyle: GroupStyle(
            activeColor: Colors.green,
          ),
          checkFirstElement: false,
          onItemSelected: (data) {
            print(data);
          },
          isExpandableTitle: false,
        ),
      ),
    ));
    await tester.pump();
    expect(controller.selectedItem, [1, 2]);
    controller.deselectAll();
    await tester.pump();
    expect(controller.selectedItem, []);
  });

  testWidgets("test deselect all in one selection  SimpleGroupedCheckbox",
      (tester) async {
    GroupController controller = GroupController(
      isMultipleSelection: false,
    );
    final values = List.generate(10, (index) => index);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SimpleGroupedCheckbox<int>(
          controller: controller,
          itemsTitle: List.generate(10, (index) => "$index"),
          values: values,
          groupStyle: GroupStyle(
            activeColor: Colors.green,
          ),
          checkFirstElement: false,
          onItemSelected: (data) {
            print(data);
          },
          isExpandableTitle: false,
        ),
      ),
    ));
    await tester.pump();
    controller.select(1);
    await tester.pump();
    expect(controller.selectedItem, 1);
    await tester.pump();
    expect(() => controller.deselectAll(), throwsA(isA<AssertionError>()));
  });
}
