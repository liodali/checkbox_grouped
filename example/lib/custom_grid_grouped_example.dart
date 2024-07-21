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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _User &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email;

  @override
  int get hashCode => name.hashCode ^ email.hashCode;
  @override
  String toString() {
    return 'email:$email,name:$name';
  }
}

class CustomGridGroupedExample extends StatefulWidget {
  final faker = Faker();

  CustomGridGroupedExample({super.key});

  @override
  State<StatefulWidget> createState() => CustomGridGroupState();
}

class CustomGridGroupState extends State<CustomGridGroupedExample> {
  final users = List<_User>.generate(
    10,
    (i) => _User(
      name: faker.person.firstName(),
      email: faker.internet.email(),
    ),
  );
  late CustomGroupController constroller = CustomGroupController(
    isMultipleSelection: true,
  );
  @override
  Widget build(BuildContext context) {
    final roundedRect = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: CustomGroupedCheckbox<_User>.grid(
            controller: constroller,
            groupTitle: Container(
              padding: const EdgeInsets.all(5.0),
              child: const Text("Custom GroupedCheckbox"),
            ),
            itemBuilder: (ctx, index, selected, isDisabled) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 6,
                ),
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: roundedRect,
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: ListTile(
                          tileColor: Colors.white,
                          title: Text(
                            users[index].name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            users[index].email,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          shape: roundedRect,
                        ),
                      ),
                      Positioned(
                        left: 10,
                        right: 10,
                        bottom: 0,
                        child: AnimatedContainer(
                          duration: const Duration(
                            milliseconds: 300,
                          ),
                          color: Colors.green[300],
                          height: selected ? 8 : 0,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            values: users,
          ),
        ),
        Builder(builder: (ctx) {
          return ElevatedButton(
            onPressed: () {
              print(constroller.selectedItem);
            },
            child: const Text("selection"),
          );
        })
      ],
    );
  }
}
