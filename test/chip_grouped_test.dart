import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("test simple SimpleGroupedChip", (tester) async {
    GroupController controller = GroupController(isMultipleSelection: false);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SimpleGroupedChips<int>(
          controller: controller,
          itemsTitle: ["1", "2", "4", "5"],
          values: [1, 2, 4, 5],
          disableItems: [2],
          chipGroupStyle: ChipGroupStyle.minimize(
            selectedColorItem: Colors.red,
            backgroundColorItem: Colors.white,
            textColor: Colors.black,
            selectedTextColor: Colors.white,
            disabledColor: Colors.grey[200],
          ),
        ),
      ),
    ));
//    await tester.tap(find.byType(ChoiceChip).first);
//    await tester.pump();
    ChoiceChip cb = tester.widget(find.byType(ChoiceChip).at(2)) as ChoiceChip;
    // ChoiceChip cb2=tester.widget(find.byType(ChoiceChip).at(2)) as ChoiceChip;
    await tester.tap(find.byWidget(cb));
    int? value = controller.selectedItem;
    expect(value, 4);
  });

  testWidgets("test multiple selection SimpleGroupedChip", (tester) async {
    GroupController controller = GroupController(
      initSelectedItem: [2, 4],
      isMultipleSelection: true,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SimpleGroupedChips<int>(
            controller: controller,
            itemsTitle: ["1", "2", "4", "5"],
            values: [1, 2, 4, 5],
            chipGroupStyle: ChipGroupStyle.minimize(
              selectedColorItem: Colors.red,
              backgroundColorItem: Colors.white,
              textColor: Colors.black,
              selectedTextColor: Colors.white,
              disabledColor: Colors.grey[200],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    var values = controller.selectedItem;
    expect(values, [2, 4]);
    FilterChip cb = tester.widget(find.byType(FilterChip).at(2)) as FilterChip;
    await tester.tap(find.byWidget(cb));
    await tester.pump(Duration(seconds: 1));
    values = controller.selectedItem;
    expect(values, [2]);
  });
}
