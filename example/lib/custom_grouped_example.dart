import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class _User {
  final String name;
  final String email;

  _User({
    required this.name,
    required this.email,
  });
  @override
  String toString() {
    return 'email:$email,name:$name';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _User &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email;

  @override
  int get hashCode => name.hashCode ^ email.hashCode;
}

class CustomGroupedExample extends StatefulWidget {
  CustomGroupedExample({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CustomGroupedExampleState();
}

class _CustomGroupedExampleState extends State<CustomGroupedExample> {
  late Faker faker = Faker();
  late final users = List<_User>.generate(
    10,
    (i) => _User(
      name: faker.person.name(),
      email: faker.internet.email(),
    ),
  );
  late CustomGroupController controller;
  @override
  void initState() {
    controller = CustomGroupController(
      isMultipleSelection: false,
      initSelectedItem: users[3],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: CustomGroupedCheckbox<_User>(
            controller: controller,
            groupTitle: Container(
              padding: EdgeInsets.all(5.0),
              child: Text("Custom GroupedCheckbox"),
            ),
            isScroll: true,
            disableItems: [users[0]],
            itemBuilder: (ctx, index, selected, isDisabled) {
              return Card(
                margin: EdgeInsets.only(
                  top: 5.0,
                  bottom: 5.0,
                ),
                child: ListTile(
                  tileColor: isDisabled
                      ? Colors.grey[400]
                      : selected
                          ? Colors.green[300]
                          : Colors.white,
                  textColor: isDisabled ? Colors.grey : null,
                  title: Text(users[index].name),
                  subtitle: Text(users[index].email),
                  trailing: Opacity(
                    opacity: selected ? 1 : 0,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              );
            },
            values: users,
          ),
        ),
        Row(
          children: [
            Builder(builder: (ctx) {
              return ElevatedButton(
                onPressed: () {
                  print(controller.selectedItem);
                },
                child: Text("selection"),
              );
            }),
            Builder(builder: (ctx) {
              return ElevatedButton(
                onPressed: () {
                  controller.clearSelection();
                },
                child: Text("DeselectAll"),
              );
            })
          ],
        ),
      ],
    );
  }
}
