import 'package:flutter/material.dart';

typedef CustomListener = void Function(dynamic);

typedef onGroupChanged<T> = void Function(dynamic selected);

enum GroupedType { Chips, Switch, Default }

class ChipsStyle {
  final bool isScrolling;
  final Color backgroundColorItem;
  final Color? disabledColor;
  final Color selectedColorItem;
  final Color textColor;
  final Color selectedTextColor;
  final IconData? selectedIcon;

  const ChipsStyle({
    this.backgroundColorItem = Colors.grey,
    this.disabledColor,
    this.selectedColorItem = Colors.black,
    this.selectedIcon,
    this.selectedTextColor = Colors.white,
    this.textColor = Colors.black,
    this.isScrolling = false,
  });
}
