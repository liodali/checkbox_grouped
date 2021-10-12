import 'package:flutter/material.dart';

typedef CustomListener = void Function(dynamic);

typedef OnGroupChanged<T> = void Function(dynamic selected);
typedef OnCustomGroupChanged<T> = void Function(Map<int,dynamic> selected);

/// Signature for a function that creates a widget for a given index,isChecked and disabled, e.g., in a
/// list.
typedef CustomItemIndexedWidgetBuilder = Widget Function(
  BuildContext builder,
  int index,
  bool checked,
  bool isDisabled,
);

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
