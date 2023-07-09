import 'package:checkbox_grouped/src/controller/custom_group_controller.dart';
import 'package:checkbox_grouped/src/controller/group_controller.dart';
import 'package:flutter/material.dart';

abstract class BaseSimpleGrouped<T> extends StatefulWidget {
  final GroupController controller;
  final List<T> values;
  final List<String> itemsTitle;
  final List<T> disableItems;

  const BaseSimpleGrouped({
    Key? key,
    required this.controller,
    required this.values,
    required this.itemsTitle,
    this.disableItems = const [],
  }):super(key: key);
}

abstract class BaeCustomGrouped<T> extends StatefulWidget {
  final CustomGroupController controller;
    final List<T> values;

  const BaeCustomGrouped({
    Key? key,
    required this.controller,
    required this.values,
  }):super(key: key);
}

abstract class BaeListGrouped extends StatefulWidget {}
