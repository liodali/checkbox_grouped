import 'dart:math';

import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class GridOfListGroupedCheckbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = 10;
    final listOfController = List.generate(
        size, (index) => GroupController(isMultipleSelection: true));
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 368,
          mainAxisSpacing: 5.0,
        ),
        itemCount: size,
        shrinkWrap: true,
        itemBuilder: (ctx, index) {
          final data = List.generate(
              Random().nextInt(4) + 1, (index) => faker.company.suffix());
          return DefaultTextStyle(
            style: TextStyle(fontSize: 11),
            child: SimpleGroupedCheckbox(
              controller: listOfController[index],
              groupTitle: faker.company.position(),
              helperGroupTitle: false,
              values: data,
              itemsTitle: data,
              isLeading: true,
            ),
          );
        });
  }
}
