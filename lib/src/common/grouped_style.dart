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
class _BaseGroupStyle {
  final Color? activeColor;
  final TextStyle? groupTitleStyle;
  final TextStyle? itemTitleStyle;
  final TextStyle? subItemTitleStyle;

  _BaseGroupStyle({
    this.activeColor,
    this.groupTitleStyle,
    this.itemTitleStyle,
    this.subItemTitleStyle,
  });
}

class GroupStyle extends _BaseGroupStyle {
  GroupStyle({
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
