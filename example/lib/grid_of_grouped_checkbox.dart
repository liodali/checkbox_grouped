import 'dart:math';

import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class _Permission {
  final String name;

  _Permission({
    required this.name,
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
  const GridOfListGroupedCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    const size = 10;
    final listOfController = List.generate(
        size, (index) => GroupController(isMultipleSelection: true));
    return SingleChildScrollView(
      primary: true,
      scrollDirection: Axis.vertical,
      child: SizedBox(
        height: 368 * 5.1,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    groupStyle: const GroupStyle(
                      helperGroupTitle: false,
                      isLeading: true,
                    ),
                    values: data,
                    itemsTitle: data.map((e) => e.name).toList(),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                debugPrint(listOfController[0].selectedItem);
              },
              child: const Text("get data"),
            ),
          ],
        ),
      ),
    );
  }
}
