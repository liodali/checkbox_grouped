import 'package:flutter/material.dart';
/// [_BaseGroupedStyle]: base class for style groupedCheckbox,Switch,Chips
///
/// [activeColor]        : (Color) choose the color to use when this checkbox button is selected
///
/// [groupTitleStyle]    : (TextStyle) Text Style  that describe style of group title of group checkbox
///
/// [itemTitleStyle]     : (TextStyle) Text Style  that describe style of title of each item in  group checkbox
///
/// [subItemTitleStyle]  : (TextStyle) Text Style  that describe style of subtitle of each item in  group checkbox
class _BaseGroupedStyle {
  final Color? activeColor;
  final TextStyle? groupTitleStyle;
  final TextStyle? itemTitleStyle;
  final TextStyle? subItemTitleStyle;

  _BaseGroupedStyle({
    this.activeColor,
    this.groupTitleStyle,
    this.itemTitleStyle,
    this.subItemTitleStyle,
  });
}

class GroupedStyle extends _BaseGroupedStyle {
  GroupedStyle({
    Color? activeColor,
    TextStyle? groupTitleStyle,
    TextStyle? itemTitleStyle,
    TextStyle? subItemTitleStyle,
  }) : super(
          activeColor: activeColor,
          groupTitleStyle: groupTitleStyle,
          itemTitleStyle: itemTitleStyle,
          subItemTitleStyle: subItemTitleStyle,
        );
}
