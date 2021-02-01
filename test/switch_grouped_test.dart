import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("test single selection SimpleGroupedSwitch ", (tester) async {
    GroupController controller = GroupController();
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SimpleGroupedSwitch<int>(
          controller: controller,
          itemsTitle: ["1", "2", "4", "5"],
          values: [1, 2, 4, 5],
          textStyle: TextStyle(color: Colors.black),
        ),
      ),
    ));

    await tester.pump();

    await tester.tap(find.byType(SwitchListTile).at(1));
    await tester.pump();
    expect(controller.selectedItem, 2);
  });
  testWidgets("test multiple selection SimpleGroupedSwitch ", (tester) async {
    GroupController controller = GroupController(
      isMultipleSelection: true,
    );
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SimpleGroupedSwitch<int>(
          controller: controller,
          itemsTitle: ["1", "2", "4", "5"],
          disableItems: [2, 4],
          values: [1, 2, 4, 5],
          textStyle: TextStyle(color: Colors.black),
        ),
      ),
    ));

    await tester.pump();

    await tester.tap(find.byType(SwitchListTile).at(1));
    await tester.pump();
    expect(controller.selectedItem, []);

    await tester.tap(find.byType(SwitchListTile).at(0));
    await tester.pump();
    await tester.tap(find.byType(SwitchListTile).at(2));
    await tester.pump();
    expect(controller.selectedItem, [1]);
  });
  testWidgets("test enable/disable item  SimpleGroupedSwitch ", (tester) async {
    GroupController controller = GroupController(
      isMultipleSelection: true,
      initSelectedItem: [2, 3],
    );
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SimpleGroupedSwitch<int>(
          controller: controller,
          itemsTitle: List.generate(10, (index) => "$index"),
          values: List.generate(10, (index) => index),
          textStyle: TextStyle(fontSize: 16),
          activeColor: Colors.red,
          onItemSelected: (values) {
            print(values);
          },
        ),
      ),
    ));
    await tester.pump();
    expect(controller.selectedItem, [2, 3]);
    controller.disabledItemsByValues([2]);
    await tester.pump();
    await tester.tap(find.byType(SwitchListTile).at(2));
    await tester.pump();
    await tester.tap(find.byType(SwitchListTile).at(3));
    await tester.pump();
    expect(controller.selectedItem, [2]);
    controller.enabledItemsByValues([2]);
    await tester.pump();
    await tester.tap(find.byType(SwitchListTile).at(2));
    await tester.pump();
    expect(controller.selectedItem, []);
  });
}
