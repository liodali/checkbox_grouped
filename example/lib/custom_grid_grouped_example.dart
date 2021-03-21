import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class _User {
  final String name;
  final String email;

  _User({
    this.name,
    this.email,
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
}

class CustomGridGroupedExample extends StatelessWidget {
  final faker = Faker();

  CustomGridGroupedExample({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final users = List<_User>.generate(
      10,
      (i) => _User(
        name: faker.person.firstName(),
        email: faker.internet.email(),
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: CustomGroupedCheckbox<_User>.grid(
            controller: CustomGroupController(isMultipleSelection: true),
            groupTitle: Container(
              padding: EdgeInsets.all(5.0),
              child: Text("Custom GroupedCheckbox"),
            ),
            itemBuilder: (ctx, index, selected, isDisabled) {
              return Card(
                margin: EdgeInsets.only(
                  top: 5.0,
                  bottom: 5.0,
                ),
                child: Stack(
                  children: [
                    Center(
                      child: ListTile(
                        tileColor: Colors.white,
                        title: Text(
                          users[index].name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          users[index].email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      right: 10,
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        color: Colors.green[300],
                        height: selected ? 5 : 0,
                      ),
                    ),
                  ],
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
              print(CustomGroupedCheckbox.of(ctx).selectedItem);
            },
            child: Text("selection"),
          );
        })
      ],
    );
  }
}
