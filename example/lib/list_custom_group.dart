import 'dart:ui';

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

  @override
  String toString() {
    return "{$name,$email}";
  }
}

class ListCustomGroup extends StatelessWidget {
  const ListCustomGroup({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = ListCustomGroupController(
      isMultipleSelectionPerGroup: [
        true,
        false,
      ],
    );
    final datas = [
      List<_User>.generate(
        10,
        (i) => _User(
          name: faker.person.name(),
          email: faker.internet.email(),
        ),
      ),
      List<String>.generate(
        10,
        (i) => faker.person.name(),
      )
    ];
    return ListCustomGroupedCheckbox(
      controller: controller,
      onSelectedGroupChanged: (values) {
        print(values);
      },
      isScrollable: true,
      titleGroupedAlignment: Alignment.centerLeft,
      //groupTitles: ["Users", "Names"],
      groupTitlesWidget: [
        Align(
          alignment: Alignment.centerLeft,
          child: Card(
            color: Colors.amber[700],
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                "Users",
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              "Names",
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
      children: [
        CustomIndexedWidgetBuilder(
            itemBuilder: (ctx, index, selected, isDisabled) {
          return Card(
            margin: EdgeInsets.only(
              top: 5.0,
              bottom: 5.0,
            ),
            child: ListTile(
              tileColor: selected ? Colors.green[300] : Colors.white,
              title: Text(
                (datas[0][index] as _User).name,
              ),
              subtitle: Text(
                (datas[0][index] as _User).email,
              ),
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
        }),
        CustomGridIndexedWidgetBuilder(
            itemBuilder: (ctx, index, selected, isDisabled) {
              return Card(
                color: selected ? Colors.green[300] : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
                margin: EdgeInsets.only(
                  top: 5.0,
                  bottom: 5.0,
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        datas[1][index],
                        maxLines: 3,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 8,
                      child: Opacity(
                        opacity: selected ? 1 : 0,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 5.0)),
      ],
      listValuesByGroup: datas,
    );
  }
}
