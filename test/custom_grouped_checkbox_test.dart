import 'package:checkbox_grouped/src/controller/custom_group_controller.dart';
import 'package:checkbox_grouped/src/widgets/custom_grouped_checkbox.dart';
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
                itemBuilder: (ctx, index, v, isDisabled) {
                  return Text(
                    "$index",
                    key: Key("$index"),
                  );
                },
                values: List<int>.generate(10, (i) => i),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key("1")),warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(controller.selectedItem, 1);

    await tester.tap(find.byKey(Key("2")),warnIfMissed: false);
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
                itemBuilder: (ctx, index, v, isDisabled) {
                  return Text("$index");
                },
                values: List<int>.generate(10, (i) => i + 1),
              );
            },
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.tap(find.byType(Text).at(4),warnIfMissed: false);
    await tester.pump();
    expect(controller.selectedItem, [5]);
    await tester.tap(find.byType(Text).at(5),warnIfMissed: false);
    await tester.pump();
    expect(controller.selectedItem, [5, 6]);
  });
  testWidgets("test disable/Enable selection CustomGroupedCheckbox ",
      (tester) async {
    CustomGroupController controller =
        CustomGroupController(isMultipleSelection: true);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (ctx) {
              return CustomGroupedCheckbox<User>(
                controller: controller,
                itemBuilder: (ctx, index, v, isDisabled) {
                  return Container(
                    key: Key("$index"),
                    color: isDisabled == true ? Colors.grey : null,
                    padding: EdgeInsets.all(5.0),
                    child: Text("$index"),
                  );
                },
                values: List<User>.generate(10, (i) => User("name${i + 1}")),
              );
            },
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.tap(find.byType(Text).at(4),warnIfMissed: false);
    await tester.pump();
    expect(controller.selectedItem, [User("name5")]);
    controller.disabledItems([User("name6")]);
    await tester.tap(find.byType(Text).at(5),warnIfMissed: false);
    await tester.pump();
    expect(controller.selectedItem, [User("name5")]);
    controller.enabledItems([User("name6")]);
    await tester.tap(find.byType(Text).at(5),warnIfMissed: false);
    await tester.pump();
    expect(controller.selectedItem, [User("name5"), User("name6")]);
  });
}

class User {
  final String name;

  User(this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return "{$name}";
  }
}
