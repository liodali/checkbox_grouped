import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:checkbox_grouped/src/custom_grouped_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("test CustomGroupedCheckbox ", (tester) async {
    CustomGroupController controller = CustomGroupController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (ctx) {
              return CustomGroupedCheckbox<int>(
                controller: controller,
                itemBuilder: (ctx, index, v) {
                  return Text("$index");
                },
                itemCount: 10,
                values: List<int>.generate(10, (i) => i),
              );
            },
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.byType(Text).at(1));
    await tester.pump();
    expect(controller.selectedItem, 1);
    await tester.tap(find.byType(Text).at(2));
    await tester.pump();
    expect(controller.selectedItem, 2);
  });
  testWidgets("test multiple selection CustomGroupedCheckbox ", (tester) async {
    CustomGroupController controller =
        CustomGroupController(isMultipleSelection: true);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (ctx) {
              return CustomGroupedCheckbox<int>(
                controller: controller,
                itemBuilder: (ctx, index, v) {
                  return Text("$index");
                },
                itemCount: 10,
                values: List<int>.generate(10, (i) => i + 1),
              );
            },
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.tap(find.byType(Text).at(4));
    await tester.pump();
    expect(controller.selectedItem, [5]);
    await tester.tap(find.byType(Text).at(5));
    await tester.pump();
    expect(controller.selectedItem, [5,6]);
  });
}
