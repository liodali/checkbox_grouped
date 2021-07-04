import 'dart:math';

import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class _Permission {
  final String name;

  _Permission({
    this.name,
  });

  @override
  String toString() {
    return "Permission : $name";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _Permission &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class GridOfListGroupedCheckbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = 10;
    final listOfController = List.generate(
        size, (index) => GroupController(isMultipleSelection: true));
    return SingleChildScrollView(
      primary: true,
      scrollDirection: Axis.vertical,
      child: Container(
        height: 368 * 5.1,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 368,
                  mainAxisSpacing: 5.0,
                ),
                itemCount: size,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (ctx, index) {
                  final data = List.generate(Random().nextInt(4) + 1,
                      (index) => _Permission(name: faker.company.suffix()));
                  return SimpleGroupedCheckbox<_Permission>(
                    controller: listOfController[index],
                    groupTitle: faker.company.position(),
                    helperGroupTitle: false,
                    values: data,
                    itemsTitle: data.map((e) => e.name).toList(),
                    isLeading: true,
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print(listOfController[0].selectedItem);
              },
              child: Text("get data"),
            ),
          ],
        ),
      ),
    );
  }
}
